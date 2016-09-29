from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.chrome.options import Options
from fetch_json_input import fetch_json_input
import urllib2
import json
import csv
import re

opts = Options()
opts.add_argument(
    "user-agent=Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_3) " +
    "AppleWebKit/600.6.3 (KHTML, like Gecko) Version/8.0.6 Safari/600.6.3"
)

# driver = webdriver.Firefox()
# driver = webdriver.Chrome(chrome_options = opts)
driver = webdriver.Chrome()
driver.implicitly_wait(5)
wait = WebDriverWait(driver, 10)
driver.maximize_window()

# Navigate to SDAT search
sdat_url = 'http://sdat.resiusa.org/RealProperty/Pages/default.aspx'
driver.get(sdat_url)

# Regex for matching zip code in address
zip_code_pattern = re.compile('\d+-\d+')

city_plus_zip_pattern = re.compile('\w+\s\d+-\d+')

# Complete initial county/method form and navigate to block/lot input form
def initialize_search():
    county_menu_id = ('MainContent_MainContent_cphMainContentArea_ucSearch' +
                      'Type_wzrdRealPropertySearch_ucSearchType_ddlCounty')

    method_menu_id = ('MainContent_MainContent_cphMainContentArea_ucSearch' +
                      'Type_wzrdRealPropertySearch_ucSearchType_ddlSearchType')

    continue_button_id = ('MainContent_MainContent_cphMainContentArea' +
                          '_ucSearchType_wzrdRealPropertySearch_' +
                          'StartNavigationTemplateContainerID_btnContinue')

    postback_script = (
        "WebForm_DoPostBackWithOptions(new WebForm_PostBackOptions(\"ctl00$" +
        "ctl00$ctl00$MainContent$MainContent$cphMainContentArea$ucSearchType" +
        "$wzrdRealPropertySearch$StartNavigationTemplateContainerID$btn" +
        "Continue\", \"\", true, \"\", \"\", false, false))"
    )

    driver.execute_script(postback_script)

    driver.find_element_by_xpath(
        "//select[@id='" + county_menu_id + "']/option[@value='03']"
    ).click()

    driver.find_element_by_xpath(
        "//select[@id='" + method_menu_id + "']/option[@value='03']"
    ).click()

    continue_button_id = ('MainContent_MainContent_cphMainContentArea_uc' +
                          'SearchType_wzrdRealPropertySearch_StartNavigation' +
                          'TemplateContainerID_btnContinue')

    continue_button = wait.until(
        EC.element_to_be_clickable((By.ID, continue_button_id))
    )

    continue_button.click()

# Navigate back to block/lot input page
def navigate_previous():
    previous_button_id = ('MainContent_MainContent_cphMainContentArea_uc' +
                          'SearchType_wzrdRealPropertySearch_btnPrevious_top2')

    previous_button = wait.until(
        EC.element_to_be_clickable((By.ID, previous_button_id))
    )

    previous_button.click()

# Complete and submit block/lot input form
def search_block_lot(block, lot):
    block_input_id = ('MainContent_MainContent_cphMainContentArea_ucSearch' +
                      'Type_wzrdRealPropertySearch_ucEnterData_txtMap_Block')
    lot_input_id = ('MainContent_MainContent_cphMainContentArea_ucSearch' +
                    'Type_wzrdRealPropertySearch_ucEnterData_txtMap_Lot')

    # Enter block and lot
    block_input_field = driver.find_elements_by_css_selector(
        "input[type='text'][id='" + block_input_id + "']"
    )[0]
    block_input_field.clear()
    block_input_field.send_keys(block)

    lot_input_field = driver.find_elements_by_css_selector(
        "input[type='text'][id='" + lot_input_id + "']"
    )[0]
    lot_input_field.clear()
    lot_input_field.send_keys(lot)

    next_button_id = ('MainContent_MainContent_cphMainContentArea_ucSearch' +
                      'Type_wzrdRealPropertySearch_StepNavigationTemplate' +
                      'ContainerID_btnStepNextButton')

    next_button = wait.until(
        EC.element_to_be_clickable((By.ID, next_button_id))
    )
    next_button.click()

# Collect property info from page elements
def parse_property_fields():
    property_info = {}

    premises_address_span_id = ('MainContent_MainContent_cphMainContentArea' +
                           '_ucSearchType_wzrdRealPropertySearch_ucDetails' +
                           'Search_dlstDetaisSearch_lblPremisesAddress_0')

    owner_span_id = ('MainContent_MainContent_cphMainContentArea_ucSearch' +
                     'Type_wzrdRealPropertySearch_ucDetailsSearch_dlst' +
                     'DetaisSearch_lblOwnerName_0')

    use_span_id = ('MainContent_MainContent_cphMainContentArea_ucSearch' +
                   'Type_wzrdRealPropertySearch_ucDetailsSearch_dlstDetais' +
                   'Search_lblUse_0')

    mailing_address_elem_id = ('MainContent_MainContent_cphMainContentArea' +
                               '_ucSearchType_wzrdRealPropertySearch_uc' +
                               'DetailsSearch_dlstDetaisSearch_lblMailing' +
                               'Address_0')

    # Extract zip code from premises address
    property_info['premises_address'] = driver.find_element_by_id(
        premises_address_span_id
    ).text.replace('\n', ' ')

    zip_code = re.findall(
        zip_code_pattern, property_info['premises_address']
    )

    if str(zip_code[0]) == '0-0000':
        property_info['zip_code'] = ''
    else:
        property_info['zip_code'] = str(zip_code[0])

    city_match = re.findall(
        city_plus_zip_pattern, property_info['premises_address']
    )[0]

    property_info['city'] = re.sub(
        zip_code_pattern, '', city_match
    ).strip()

    # Get full owner name
    owner_span = driver.find_element_by_id(owner_span_id)
    owner_name_td = owner_span.find_element_by_xpath('..')
    property_info['owner'] = owner_name_td.text.replace('\n', ' ')

    property_info['use'] = driver.find_element_by_id(
        use_span_id
    ).text

    # Remove comma from mailing address
    mailing_address_text = driver.find_element_by_id(
        mailing_address_elem_id
    ).text

    property_info['mailing_address'] = re.sub(r',', '', mailing_address_text)

    return property_info

def write_to_csv(scraped_info, input_info, writer):
    # Check validity of input address
    if not 'buildingaddress' in input_info or input_info['buildingaddress'] == '0':
        # Trim scraped premises address
        scraped_address = re.sub(
            city_plus_zip_pattern, '', scraped_info['premises_address']
        ).strip()
        resulting_address = scraped_address
    else:
        resulting_address = input_info['buildingaddress']

    # Write row of data to CSV
    writer.writerow([
        resulting_address, input_info['block'],
        input_info['lot'], scraped_info['zip_code'], scraped_info['city'],
        input_info['neighborhood'], input_info['policedistrict'],
        input_info['councildistrict'], input_info['location']['longitude'],
        input_info['location']['latitude'], scraped_info['owner'],
        scraped_info['use'],
        scraped_info['mailing_address'].replace('\n', ' ')
    ])

# Fetch and log data for each property in data set
def fetch_all_property_info(num_props):
    json_input = fetch_json_input(num_props)
    initialize_search()
    with open('out.csv', 'w') as out_file:
        writer = csv.writer(out_file, delimiter = ',')
        # Write CSV headers
        writer.writerow([
            'building_address', 'block', 'lot', 'zip_code', 'city',
            'neighborhood', 'police_district', 'council_district',
            'longitude', 'latitude', 'owner', 'use', 'mailing_address'
        ])

        for obj in json_input:
            if (obj['block'] == '0180' and obj['lot'] == '020') or (obj['block'] == '0259' and obj['lot'] == '016'):
                continue
            else:
                search_block_lot(obj['block'], obj['lot'])
                scraped_info = parse_property_fields()
                write_to_csv(scraped_info, obj, writer)
                navigate_previous()

    driver.quit()

fetch_all_property_info(20000)
