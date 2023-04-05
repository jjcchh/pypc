def scrape_data(base_url):
    """Scrape data from an Amazon webpage.
    
    Keyword arguments:
    base_url -- the webpage url to be scraped
    """
    import pandas as pd
    import requests
    from bs4 import BeautifulSoup

    headers = {
        'authority': 'www.amazon.com',
        'cache-control': 'max-age=0',
        'rtt': '300',
        'downlink': '1.35',
        'ect': '3g',
        'sec-ch-ua': '"Google Chrome"; v="83"',
        'sec-ch-ua-mobile': '?0',
        'upgrade-insecure-requests': '1',
        'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36',
        'accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9',
        'sec-fetch-site': 'none',
        'sec-fetch-mode': 'navigate',
        'sec-fetch-user': '?1',
        'sec-fetch-dest': 'document',
        'accept-language': 'en-GB,en-US;q=0.9,en;q=0.8'
    }
    
    response = requests.get(base_url, headers=headers)
    html_content = response.text

    soup = BeautifulSoup(html_content, "html.parser")
    search_results = soup.find("div", {"class": "s-search-results"})

    product_listings = search_results.find_all("div", {"data-component-type": "s-search-result"})

    products = []
    # Iterate through the product listing
    for listing in product_listings:
        product = {}

        product["title"] = listing.find("h2", {"class": "a-size-mini"}).text.strip()

        try:
            product["price"] = listing.find("span", {"class": "a-price-whole"}).text.strip() + listing.find("span", {"class": "a-price-fraction"}).text.strip()
        except AttributeError:
            product["price"] = "N/A"

        try:
            product["rating"] = listing.find("span", {"class": "a-icon-alt"}).text.strip().split()[0]
        except AttributeError:
            product["rating"] = "N/A"

        try:
            product["num_reviews"] = listing.find("span", {"class": "a-size-base s-underline-text"}).text.strip().split()[0]
        except AttributeError:
            product["num_reviews"] = "N/A"

        products.append(product)

    df = pd.DataFrame(products)
    
    return df