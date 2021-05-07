from telegram import Update
from telegram.ext import Updater, CommandHandler, CallbackContext
import re

def mac2ip(update, context):
    MAC = str(context.args[0])
    IP = outputMAC(MAC)
    if not IP:
        update.message.reply_text("Gia tri MAC khong thoa man")
    else:
        update.message.reply_text("IP cua MAC: " + str(IP) )
    # except (IndexError, ValueError):
    #   update.message.reply_text("There is not enough number")
        

def outputMAC(MAC):
    with open("/var/dhcp.leases") as f:
        data = f.read()
        # data_json = json.loads(data)
        pattern = re.compile(r"lease ([0-9.]+) {.*?hardware ethernet ([:a-f0-9]+);.*?}", re.MULTILINE | re.DOTALL)
    s = {}
    with open("/var/dhcp.leases") as f:
        for match in pattern.finditer(f.read()):
            s.update({match.group(2): match.group(1)})
    if MAC in s:
        result = s[MAC]
    else: 
        result = None
    return result

def main():
    updater = Updater('1828936471:AAH-5fzHIKSsgVxyKMrv26gEyAa3CmUr89s')
    dp = updater.dispatcher
    dp.add_handler(CommandHandler("mac2ip", mac2ip))
    updater.start_polling()
    updater.idle()

if __name__ == '__main__':
    main()