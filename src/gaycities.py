import bs4
import requests
import os
import pandas as pd
import time

from bs4 import BeautifulSoup

base_url = 'http://www.gaycities.com/'
wayback_url = 'https://web.archive.org/web/20070728021740/'
scrape_url = wayback_url + base_url

gaycities = requests.get(scrape_url)

with open('data/gaybars/gaycities/html/gaycities.html', 'w') as f:
    f.write(gaycities.text)

soup = BeautifulSoup(gaycities.text, 'html.parser')
citylist = soup.find(id='citylist')
cities = []
for link in citylist.find_all('a'):
    cities.append({'city': link.text, 'url': link.get('href')})

pd.DataFrame(cities).to_csv('data/gaybars/gaycities/gaycities.csv', index=False)

bar_list = []
error_list = []
for city in cities:
    try:
        time.sleep(.5)
        city_page = requests.get(city['url'])
        page_name = city['city'].lower().replace(' ', '_').replace('/_', '').replace(',', '')
        with open('data/gaybars/gaycities/html/{}.html'.format(page_name), 'w') as f:
            f.write(city_page.text)

        city_soup = BeautifulSoup(city_page.text, 'html.parser')
        city['header'] = city_soup.find(id='yui-main').find('h2').text
        flavortext = city_soup.find(id='yui-main').find('big').contents
        city['flavortext'] = flavortext[-1] if len(flavortext) > 0 else ''

        time.sleep(.5)
        bars_url = city['url'] + 'bars'
        city_bars = requests.get(bars_url)
        with open('data/gaybars/gaycities/html/{}_bars.html'.format(page_name), 'wb') as f:
            f.write(city_bars.text.encode('utf8'))

        bar_soup = BeautifulSoup(city_bars.text, 'html.parser')
        for bar in bar_soup.find('ol', class_='listings').find_all('li'):
            name = bar.contents[3].text
            url = bar.contents[3].get('href')
            address = bar.find_all('span', class_='subinfo')[-1].text.strip()
            if ' - ' in address:
                neighborhood = address.split(' - ')[0]
                address = address.split(' - ')[1]
            else:
                neighborhood = ''
            string_children = [child.strip() for child in bar.contents if isinstance(child, bs4.element.NavigableString)]
            string_children = list(filter(lambda x: len(x) > 0, string_children))
            description = string_children[0] if len(string_children) > 0 else ''
            bar_list.append({'city': city['city'], 'name': name, 'url': url, 'address': address, 'neighborhood': neighborhood, 'description': description})

        # are there multiple pages of bars?
        page_count = 1
        navigation_buttons = bar_soup.find_all(class_="nextpage")
        next_button = navigation_buttons[1] if len(navigation_buttons) > 0 else None
        while next_button is not None and not 'disabled' in next_button.attrs['class']:
            # increase page count, get link to next page
            page_count += 1
            next_page = next_button.a.get('href')

            time.sleep(.5)
            city_bars = requests.get(next_page)
            with open('data/gaybars/gaycities/html/{0}_bars{1}.html'.format(page_name, page_count), 'wb') as f:
                f.write(city_bars.text.encode('utf8'))

            bar_soup = BeautifulSoup(city_bars.text, 'html.parser')
            for bar in bar_soup.find('ol', class_='listings').find_all('li'):
                name = bar.contents[3].text
                url = bar.contents[3].get('href')
                address = bar.find_all('span', class_='subinfo')[-1].text.strip()
                if ' - ' in address:
                    neighborhood = address.split(' - ')[0]
                    address = address.split(' - ')[1]
                else:
                    neighborhood = ''
                string_children = [child.strip() for child in bar.contents if isinstance(child, bs4.element.NavigableString)]
                string_children = list(filter(lambda x: len(x) > 0, string_children))
                description = string_children[0] if len(string_children) > 0 else ''
                bar_list.append({'city': city['city'], 'name': name, 'url': url, 'address': address, 'neighborhood': neighborhood, 'description': description})

            # check next button again
            next_button = bar_soup.find_all(class_="nextpage")[1]

    except Exception as e:
        print(e)
        error_info = city.copy()
        error_info.update({'error': e})
        error_list.append(error_info)

cities_df = pd.DataFrame(cities, columns=['city', 'header', 'flavortext', 'url'])
bar_df = pd.DataFrame(bar_list, columns=['city', 'name', 'address', 'neighborhood', 'description', 'url'])

cities_df.to_csv('data/gaybars/gaycities/gaycities.csv', index=False)
bar_df.to_csv('data/gaybars/gaycities/gaycities_bars.csv', index=False)
