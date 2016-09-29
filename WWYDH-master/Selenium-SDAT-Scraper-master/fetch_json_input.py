import json
import urllib2

JSON_UPPER_LIMIT = 10

def fetch_json_input(upper_limit):
    base_url = 'https://data.baltimorecity.gov/resource/qqcv-ihn5.json'
    url_with_limit = base_url + '?$limit=' + str(upper_limit)

    # Specify offset
    url_with_limit = url_with_limit + '&$offset=12133'

    req = urllib2.Request(url_with_limit)
    req.add_header('X-App-Token', 'T7sam5BxdH4KFsmfePLl0mkNU')
    response = urllib2.urlopen(req)

    unicode_json = json.load(response)

    # Formatted print for JSON data
    # json_as_string = json.dumps(unicode_json, indent = 4)
    # print(json_as_string)

    return unicode_json

if __name__ == "__main__":
    print(fetch_json_input(JSON_UPPER_LIMIT))
