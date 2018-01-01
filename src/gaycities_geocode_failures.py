import bs4
import requests
import numpy as np
import os
import pandas as pd
import time
import yaml

from bs4 import BeautifulSoup

gaycities_geocode_failures = pd.read_csv('data/gaybars/gaycities/gaycities_geocode_failures.csv')

# os.mkdir('data/gaybars/gaycities/html/barpages')
#
# pages = []
# errors = []
# for index, bar in gaycities_geocode_failures.iterrows():
#     try:
#         time.sleep(.5)
#         bar_page = requests.get(bar['url'])
#         page_name = bar['city'].lower().replace(' ', '_').replace('/_', '').replace(',', '') + str(bar['id'])
#         with open('data/gaybars/gaycities/html/barpages/{}.html'.format(page_name), 'wb') as f:
#             f.write(bar_page.text.encode('utf8'))
#         pages.append({'id': bar['id'], 'text': bar_page.text})
#     except Exception as e:
#         print(e)
#         error_info = dict(bar.copy())
#         error_info.update({'error': e})
#         error_list.append(error_info)
#
# success_pages = []
# fail_pages = []
# for page in pages:
#     try:
#         bar_soup = BeautifulSoup(page['text'], 'html.parser')
#         address_cell = bar_soup.find(id='container').find('td')
#         string_children = [child.strip() for child in address_cell.contents if isinstance(child, bs4.element.NavigableString)]
#         string_children = list(filter(lambda x: len(x) > 0, string_children))
#         address = ', '.join(string_children)
#         if len(address) == 0:
#             # Wayback Machine is pulling this page from after a UI revamp
#             # so the location of the address is slightly different
#             updated_address_cell = address_cell.find('p', class_='keydetail')
#             string_children = [child.strip() for child in updated_address_cell.contents if isinstance(child, bs4.element.NavigableString)]
#             string_children = list(filter(lambda x: len(x) > 0, string_children))
#             address = ', '.join(string_children)
#         success_pages.append({'id': page['id'], 'address': address})
#     except Exception as e:
#         # the only error obvserved indicates that the bar was never archived
#         # on the Wayback Machine. This vindicates my choice to use the
#         # main list of bars instead of individual bar pages for the majority
#         # of bars, and only to get bar pages in cases of difficulty.
#         print(e)
#         fail_pages.append({'id': page['id'], 'error': e})
#
# # the errors are the pages that don't exist in the wayback machine!
# # st louis is an awk donate page...
# fail_pages
#
# # Fire Island will be a problem, but I don't care
# success_pages
#
# new_addresses = pd.DataFrame(success_pages)
#
# # the right way to do this is to turn the column into an index and use update()
# # but will that leave the data frame in the form I want it?
#
#
# gaycities_new_addresses = gaycities_geocode_failures.merge(new_addresses,
#                                                            on='id',
#                                                            how='left',
#                                                            suffixes=('','_new'))
#
# # https://stackoverflow.com/questions/35068722/pandas-assign-value-of-one-column-based-on-another
# gaycities_new_addresses['address'] = (
#     gaycities_new_addresses['address'].where(
#         pd.isna(gaycities_new_addresses['address_new']),
#         gaycities_new_addresses['address_new']
#     ))
#
# gaycities_new_addresses.drop(columns=['address_new'], inplace=True)
#
# gaycities_new_addresses.to_csv('data/gaybars/gaycities/gaycities_geocode_failures_update_addresses.csv', index=False)
#
# # make google maps requests
# # save with lat / lon
# # make census requests
# # merge with other geocoded data
# # (Will need to recollect census data, not now, but eventually!)
#
# # Google Maps
# google_maps_url = 'https://maps.googleapis.com/maps/api/geocode/json'
# with open('src/google_maps.yml', 'r') as f:
#     google_maps_cfg = yaml.load(f)
#
# gm_responses = []
# gm_errors = []
# # make requests
# for index, bar in gaycities_new_addresses.iterrows():
#     try:
#         time.sleep(.5)
#         params = {'address': bar['address'], 'key': google_maps_cfg['api_key']}
#         r = requests.get(google_maps_url, params=params)
#         gm_responses.append({'id': bar['id'], 'response': r})
#     except Exception as e:
#         print(bar['id'])
#         print(e)
#
# # process valid responses
# for response in gm_responses:
#     r = response['response']
#     if r.status_code == 200:
#         try:
#             if len(r.json()['results']) > 1:
#                 # only one bar has duplicate locations
#                 # because it has "4th floor" in the address
#                 # and an incorrect zip code---02118 instead of 02111
#                 # manually correcting this here
#                 location = r.json()['results'][1]['geometry']['location']
#             else:
#                 location = r.json()['results'][0]['geometry']['location']
#             response['lat'] = location['lat']
#             response['lng'] = location['lng']
#         except:
#             print(r.text)

# import pickle
# pickle.dump(gm_responses, open('data/gaybars/gaycities/tmp_gm_responses.pkl', 'wb'))

# TODO: above code is now redundant, remove
# make Census requests with valid lat / lon
census_responses = []
for index, response in gaycities_geocode_failures.iterrows():
    try:
        time.sleep(.5)
        census_geocode_url = 'https://geocoding.geo.census.gov/geocoder/geographies/coordinates'
        params = {
            'benchmark': 'Public_AR_Current',
            'vintage': 'Current_Current',
            'x': response['lng'],
            'y': response['lat'],
            'format': 'json'
        }
        r = requests.get(census_geocode_url, params=params)
        census_responses.append({'id': response['id'], 'response': r})
    except Exception as e:
        print(e)
        print(response['id'])

# add Census output to data frame with same structure  as original
for r in census_responses:
    try:
        block = r['response'].json()['result']['geographies']['2010 Census Blocks'][0]
        tract = r['response'].json()['result']['geographies']['Census Tracts'][0]
        r['state'] = tract['STATE']
        r['county'] = tract['COUNTY']
        r['tract'] = tract['TRACT']
        r['block'] = block['BLOCK']
        r['GEOID'] = tract['GEOID']
    except Exception as e:
        print(r['id'])
        print(r['response'].text)

# fixed random errors in statuses
# responses_with_errors = [r for r in gm_responses if r['id'] in [143, 387, 489, 588]]
check_responses = [r for r in census_responses if r['id'] in [15, 384, 393, 588]]
#
for r in census_responses:
    if r['id'] in [384]:
        census_responses.remove(r)

rows = gaycities_geocode_failures.loc[gaycities_geocode_failures['id'] == 384]

for index, response in rows.iterrows():
    try:
        time.sleep(.5)
        census_geocode_url = 'https://geocoding.geo.census.gov/geocoder/geographies/coordinates'
        params = {
            'benchmark': 'Public_AR_Current',
            'vintage': 'Current_Current',
            'x': response['lng'],
            'y': response['lat'],
            'format': 'json'
        }
        r = requests.get(census_geocode_url, params=params)
        census_responses.append({'id': response['id'], 'response': r})
    except Exception as e:
        print(e)
        print(response['id'])

census_responses

# join to original data frame
coords_list = []
for index, r in gaycities_geocode_failures.iterrows():
    coords = str(r['lng']) + ',' + str(r['lat'])
    coords_list.append({'id': r['id'], 'coordinates': coords})

coordinates_df = pd.DataFrame(coords_list, columns=['id', 'coordinates'])
geographies_df = pd.DataFrame(census_responses, columns=['id', 'state', 'county', 'tract', 'block', 'GEOID'])

gaycities_geocoded_by_coordinates = (
    gaycities_geocode_failures.
        rename(columns={'state': 'state_abbreviation'}).
        merge(coordinates_df, on='id').
        merge(geographies_df, on='id'))

gaycities_geocoded_by_coordinates.to_csv('data/gaybars/gaycities/gaycities_geocoded_by_coordinates.csv', index=False)
