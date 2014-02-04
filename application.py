# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


'''
TODO: あまりにも操作が多くなるようならblueprintを使う or 別のフレームワークで書き直す
'''


import sys
from os import (environ, )

if 'SPHINXBUILD' not in environ:
    print('you should assign $SPHINXBUILD')
    sys.exit(2)

from flask import (Flask, Response, render_template, jsonify, request, )


from sphinx_op import build as sphinx_build
from models.project import Projects


app = Flask(__name__)


@app.route("/")
def index():
    projects = Projects()
    return render_template('main.html', projects=projects.get_all())


@app.route("/build/<int:entry_id>")
def build(entry_id):
    result, err = sphinx_build(project_id=entry_id)
    return Response(result + '\n' + err, mimetype='text/plain')


@app.route("/entries", methods=['GET', 'POST'])
def get_entries():
    '''
    # 'GET'
        You can get all entries is controlled.

    .. highlight:: json
        {
            'entries': [
                {
                    'id': 1,
                    'name': 'foo'
                },
            ]
        }


    # 'POST'
        You can create new Sphinx project.
        TODO: add certification

    ## CONTENT

    .. NOTE::
        you should refer the usage of command names `sphinx-quickstart`

    - require
        - Project Name
        - Version
        - Author Name
    - optional
        - Separate?
        - Prefix
        - Relarse Version (default is same as Version)
        ... ...
    '''
    def GET():
        projects = Projects()
        return jsonify(
            {'entries': [proj._asdict() for proj in projects.get_all()]}
        )

    def POST():
        # REQUIRE_PARAMS = ['project_name', 'version', 'author_name', ]
        # posted_params = request.json
        # if any(param for param in REQUIRE_PARAMS if param not in posted_params):
        return jsonify(err='implementaition is pending.')

    if request.method == 'GET':
        return GET()
    elif request.method == 'POST':
        return POST()


@app.route('/entry/<int:entry_id>', methods=['GET', 'POST'])
def edit_entry(entry_id):
    def GET():
        '''
        get all information of project
        '''
        targ = Projects().get(entry_id)[0].as_tree()
        return jsonify(target=targ)

    def POST():
        '''
        add or edit file contained in project
        '''

    if request.method == 'GET':
        return GET()
    elif request.method == 'POST':
        return POST()



if __name__ == "__main__":
    app.debug = True  # enable debug while developping
    app.run()
