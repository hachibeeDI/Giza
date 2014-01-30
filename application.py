# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, )


from flask import Flask
app = Flask(__name__)

@app.route("/")
def hello():
    return "Hello World!"

if __name__ == "__main__":
    app.run()
