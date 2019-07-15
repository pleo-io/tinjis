#!/usr/bin/env python
import os
from app import create_app

app = create_app('development')

if __name__ == '__main__':
    app.run(port=9000)

