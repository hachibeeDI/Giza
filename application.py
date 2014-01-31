# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


import sys
from os import (path, environ, listdir, )
from collections import namedtuple

if 'SPHINXBUILD' not in environ:
    print('you should assign $SPHINXBUILD')
    sys.exit(2)

from flask import (Flask, render_template, )


app = Flask(__name__)

#               FIXME: for tests.
PROJECTS_ROOT = path.dirname(path.abspath(__file__))
PATH_TO_PROJECT = 'projects'


# TODO: ここは後でSQLAlchemyのモデルとして定義する
Project = namedtuple('Project', 'id name')
def _get_projects():
    return [Project(i, name) for i, name in enumerate(listdir(path.join(PROJECTS_ROOT, PATH_TO_PROJECT)))]


@app.route("/")
def index():
    # TODO: ◆予定◆ ここは実際sqlな ◆実現可能性◆
    projects = _get_projects()
    return render_template('main.html', projects=projects)


@app.route("/build/<int:entry_id>")
def build(entry_id):
    # make_mainを呼び出そうかと考えたが、それだと初期設定の反映のためにMakefileの
    # パースが必要になるのでやめた。
    # from sphinx import main, make_main
    import subprocess
    target_task = 'html'
    projects = _get_projects()
    # TODO: SQLな
    target_project = ''.join([proj.name for proj in projects if proj.id == entry_id])
    if not target_project:
        return 'Invalid id'
    p = subprocess.Popen('cd {0}/{1}/{2}; make {3}'.format(PROJECTS_ROOT, PATH_TO_PROJECT, target_project, target_task, ),
                         stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
    out = p.stdout.read()
    err = p.stderr.read()
    return out + err


if __name__ == "__main__":
    app.debug = True  # enable debug while developping
    app.run()
