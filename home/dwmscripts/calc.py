import os
from typing import List
import subprocess
import requests


def get_ex_rates() -> float:
    response = \
        requests.get("https://www.cbr-xml-daily.ru/daily_json.js").json()
    out = {}
    for valute in response["Valute"]:
        out[valute] = response["Valute"][valute]["Value"]
    return out


def show_command_out(command: str, return_out: str = True) -> str | None:
    if not return_out:
        os.system(command)
        return
    return subprocess.check_output(
        command,
        shell=True
    ).decode("utf-8")


def show_dmenu_out(question: str, answers: List[str] = None) -> str:
    if not answers:
        return show_command_out(
            'cat /dev/null | dmenu -p "{}"'.format(
                question
            )
        )[:-1]
    return show_command_out(
        'echo "{}" | dmenu -p "{}"'.format(
            "".join([f"{x}\n" for x in answers])[:-1],
            question
        )
    )[:-1]


def main() -> None:
    sentence = show_dmenu_out(">")
    try:
        ex_rates = get_ex_rates()
        for ex_rate in ex_rates:
            globals()[ex_rate] = ex_rates[ex_rate]
        answer = str(eval(sentence))
    except Exception as exc:
        answer = str(exc)
    do_copy = show_dmenu_out(f"{sentence} = {answer}", ["Exit", "Copy"])
    if do_copy == "Copy":
        show_command_out(
            f'echo "{answer}" | xclip -selection clipboard -r',
            False
        )


if __name__ == '__main__':
    main()
