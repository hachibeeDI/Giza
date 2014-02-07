# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


from os import (path, )

from flask import (jsonify, )

from .project import Projects


def _write_content(full_path, content):
    with open(full_path, 'w') as f:
        f.write(content)


class Content(object):
    def __init__(self, entry_id, file_path):
        """"""
        self.entry_id = entry_id
        self.project = Projects().get(entry_id)[0]  # sqlだとテーブル連結的ななんかのあれにする
        self.file_path = file_path
        self._full_path = None

    @property
    def full_path(self):
        if not self._full_path:
            target_file = [_path for _path in self.project.full_files_path_as_tree()
                           if _path.endswith(self.file_path)]
            if target_file:
                self._full_path = target_file[0]
        return self._full_path


    def edit(self, content):
        full_path = self.full_path
        if full_path is None or not path.isfile(full_path):
            return jsonify({'id': self.entry_id, 'reason': 'file not exists'}), 409
        _write_content(full_path, content)
        with open(full_path, 'w') as f:
            f.write(content)
        return jsonify({'id': self.entry_id, 'status': 'success'}), 201

    def create(self, content):
        full_path = self.full_path
        if path.exists(self.full_path):
            response = jsonify({'id': self.entry_id, 'reason': 'file alredy exists.', })
            return response, 409
        _write_content(full_path, content)
        response = jsonify({'id': self.entry_id, 'status': 'success'})
        return response, 201
