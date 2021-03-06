# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


from os import (path, listdir, walk, )

from env import (PROJECTS_ROOT, PATH_TO_PROJECT, )


_RESERVED_DIR_NAME = ['build', '_build', 'extension']


def _exclude_unsource_dirs(files):
    return [f for f in files if f.split(path.sep)[1] not in _RESERVED_DIR_NAME]


class Project(object):
    '''
    TODO: ここは後でSQLAlchemyのモデルとして定義する
    '''

    def __init__(self, entry_id, name):
        self.id = entry_id
        self.name = name
        # TODO: 名前の重複が出来ないのはダサいので複数のプロジェクトルートを持てるようにする
        self.root = path.abspath(path.join(PROJECTS_ROOT, PATH_TO_PROJECT, name))
        self._files = None
        self._configfile = None

    @property
    def files(self):
        if not self._files:
            self._files = _exclude_unsource_dirs(self._files_path_as_tree())
        return self._files

    @property
    def configfile(self):
        if not self._configfile:
            self._configfile = [_path for _path in self._files if _path.endswith('conf.py')][0]
        return self._configfile


    def _files_path_as_tree(self):
        my_root_dir = self.root
        return [pth.replace(my_root_dir, '') for pth in self.full_files_path_as_tree()]

    def full_files_path_as_tree(self):
        IGNORE_DIRS = [path.join(self.root, d) for d in _RESERVED_DIR_NAME]

        ret = []
        yield_ret = ret.append
        for root, dirs, files in walk(self.root):
            for f in files:
                if any(f.startswith(ignore) for ignore in IGNORE_DIRS):
                    continue
                if f.endswith(".rst") or f.endswith(".py"):
                    yield_ret(
                        path.join(root, f))
        return ret

    def _asdict(self):
        return {
            'id': self.id,
            'name': self.name,
            'files': self.files,
            'conf': self.configfile
        }


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
