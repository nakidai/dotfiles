#!/usr/bin/env python

import json
from sys import argv, stderr

import requests

CHAT_URL = "https://duckduckgo.com/duckchat/v1/chat"
STATUS_URL = "https://duckduckgo.com/duckchat/v1/status"
HEADERS = {
	"Host": "duckduckgo.com",
	"User-Agent": "Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0",
	"Accept": "text/event-stream",
	"Accept-Language": "en-US,en;q=0.5",
	"Accept-Encoding": "gzip, deflate, br, zstd",
	"Referer": "https://duckduckgo.com/",
	"Content-Type": "application/json",
	"Origin": "https://duckduckgo.com",
	"Connection": "keep-alive",
	"Cookie": "dcm=3",
	"Sec-Fetch-Dest": "empty",
	"Sec-Fetch-Mode": "cors",
	"Sec-Fetch-Site": "same-origin",
	"x-vqd-accept": "1",
}

MODEL = "gpt-4o-mini"
PROMPT = "Перепишите следующее сообщение IRC, чтобы оно было похоже на что-то няшное и очень милое. Постарайтесь использовать побольше няшных каомодзи по типу \">.<\" или \":3\". Добавьте побольше тильд, чтобы придать игривости сообщению. Не добавляйте в сообщение новый смысл такими словами как \"привет\" и так далее. Не добавляйте в конце большую цепочку из эмодзи. Ответьте в качестве одного IRC сообщения. Вот сообщение:\n\n"
# PROMPT = "Перепишите следующее сообщение IRC, чтобы оно было похоже на что-то няшное и очень милое. Постарайтесь использовать побольше няшных каомодзи по типу \">.<\" или \":3\". Добавьте побольше тильд, чтобы придать игривости сообщению. Не добавляйте в конце большую цепочку из эмодзи. Ответьте в качестве одного IRC сообщения. Вот сообщение:\n\n"
# PROMPT = "Перепиши следующее сообщение IRC, сделав его более кавайным, как будто оно пришло от silly бойкиссера. Добавь много смайлов ':3', '>.<' и символов '~~~'. Make it cute. Ответ должен быть кратким и не содержать ничего лишнего. Пиши только строчными буквами. Вот сообщение:\n\n"

def new_conversation():
	response = requests.get(STATUS_URL, headers=HEADERS)
	return response.headers["x-vqd-4"]

def nyaa(string: str) -> str:
    try:
        req = {"model": MODEL, "messages":[{"role": "user", "content": PROMPT + string}]}
        headers = dict(HEADERS)
        headers["x-vqd-4"] = new_conversation()
        response = requests.post(CHAT_URL, headers=headers, data=json.dumps(req))

        if response.status_code != 200:
            return string

        response.encoding = "UTF-8"

        result = ""

        for line in response.text.splitlines():
            if line.strip() == "":
                continue
            if not line.startswith("data: {\"message\":"):
                continue
            result += json.loads(line[6:])["message"]

        return result
    except KeyboardInterrupt:
        raise
    except Exception:
        return string

print(nyaa(argv[1]))
