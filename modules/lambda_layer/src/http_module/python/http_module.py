import requests
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def curl(url="https://curl.haxx.se/"):
    try:
        response = requests.get(url)
    except Exception as e:
        logger.error(e)
        return False
    else:
        if response.ok:
            logger.info(response.text)
        else:
            logger.info(f'{response.status_code}: {response.reason}')
        return response.ok

if __name__ == '__main__':
    logger.info = print
    curl()
    curl('http://invalid_url')