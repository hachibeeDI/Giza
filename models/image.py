# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


from os import (path, )
from base64 import b64decode

from flask import (jsonify, )

from .project import Projects


_ALLOWED_EXTENSIONS = {'PNG', 'png', 'JPG', 'jpg', 'jpeg', 'gif'}


def make_image(entry_id):
    '''
    :rtype Image:
    '''
    return Image(Projects().get(entry_id)[0])


def _allowed_file_extention(filename):
    ext = filename.rsplit('.', 1)[1]
    return '.' in filename and ext in _ALLOWED_EXTENSIONS


def _write_content(full_path, image64_as_url):
    with open(full_path, 'wb+') as f:
        _, data = image64_as_url.split(',')
        f.write(b64decode(data))


class Image(object):
    def __init__(self, project):
        """"""
        self.id = project.id
        self.project = project
        self._full_path = None


    def create(self, content, name):
        '''
        :param {save: () -> T} content: posted file object by flask
        '''
        full_path = path.join(self.project.root, name)
        if path.exists(full_path):
            response = jsonify({'id': self.id, 'reason': 'file alredy exists.', })
            return response, 409
        if not (content or _allowed_file_extention(full_path)):
            print(content)
            print(full_path)
            response = jsonify({'id': self.id, 'reason': 'invalid file pattern.', })
            return response, 409
        _write_content(full_path, content)
        response = jsonify({'id': self.id, 'status': 'success'})
        return response, 201
