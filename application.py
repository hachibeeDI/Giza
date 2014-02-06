# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


'''
TODO: JSONを受け取る際のキー操作のエラーハンドリングについて、独自例外を作る
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
def entry(entry_id):
    def GET():
        '''
        get all information of project
        '''
        targ = Projects().get(entry_id)[0]
        return jsonify(
            id=targ.id,
            name=targ.name,
            files=targ.files_path_as_tree()
        )

    def POST():
        '''
        '''
        targ = Projects().get(entry_id)[0]
        file_path = request.json['file_path']
        full_path = [path for path in targ.full_files_path_as_tree() if path.endswith(file_path)][0]
        with open(full_path, 'r') as f:
            content = f.read()
        return jsonify({
            'id': targ.id,
            'name': targ.name,
            'file_path': file_path,
            'content': content,
        })

    if request.method == 'GET':
        return GET()
    elif request.method == 'POST':
        return POST()


@app.route('/entry/edit/<int:entry_id>', methods=['POST'])
def edit_entry(entry_id):
    '''
    require parameters
    .. highlight:: json
        {
            'file_path': '',
            'content': ''
        }
    '''
    def POST():
        request_params = request.json
        targ = Projects().get(entry_id)[0]
        file_path = request_params['file_path']
        full_path = [path for path in targ.full_files_path_as_tree() if path.endswith(file_path)][0]
        with open(full_path, 'w') as f:
            print(request_params['content'])
            f.write(request_params['content'])
        # with open(full_path, 'r') as f:
        #     print(f.read())
        #     print(f.read() == request_params['content'])
        return jsonify({
            'id': entry_id,
            'status': 'success',
        })
    return POST()



if __name__ == "__main__":
    app.debug = True  # enable debug while developping
    app.run()
