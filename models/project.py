# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


from os import (path, listdir, )
from collections import namedtuple


from env import (PROJECTS_ROOT, PATH_TO_PROJECT, )


# TODO: ここは後でSQLAlchemyのモデルとして定義する
Project = namedtuple('Project', 'id name')


class Projects(object):
    # def __init__(self, entry_id, name):
    #     self.id = entry_id
    #     self.name = name
    def get_all(self):
        # TODO: ◆予定◆ ここはモデルで実際sqlな ◆実現可能性◆
        return [Project(i, name) for i, name in enumerate(listdir(path.join(PROJECTS_ROOT, PATH_TO_PROJECT)))]

    def get(self, entry_id):
        projs = self.get_all()
        return [proj for proj in projs if proj.id == entry_id]
