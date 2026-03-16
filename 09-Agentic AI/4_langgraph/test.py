from playwright.sync_api import sync_playwright

with sync_playwright() as p:

    browser = p.chromium.launch(headless=True)
    page = browser.new_page()

    page.goto("https://news.ycombinator.com")

    titles = page.locator(".titleline a").all_text_contents()

    for i, title in enumerate(titles[:5], 1):
        print(i, title)

    browser.close()