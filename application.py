# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


'''
TODO: JSONを受け取る際のキー操作のエラーハンドリングについて、独自例外を作る
TODO: あまりにも操作が多くなるようならblueprintを使う or 別のフレームワークで書き直す
'''


import sys
from os import (environ, path, )

if 'SPHINXBUILD' not in environ:
    print('you should assign $SPHINXBUILD')
    sys.exit(2)

from flask import (Flask, Response, jsonify, request, )


from sphinx_op import build as sphinx_build
from models import (Projects, Content, make_image, )


app = Flask(__name__)


@app.route("/")
def index():
    with open('./templates/main.html', 'r') as f:
        r = Response(f.read())
    return r


@app.route("/previews/<path:filename>")
def previews(filename):
    '''
    This routing is in order to local debuging.
    So you should setup the web server is suite for serving static files(e.g. Apache, Nginx... ... ).
    '''
    ROOT = './projects/'
    with open(path.join(ROOT, filename), 'r') as f:
        r = Response(f.read())
    return r


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
        return jsonify({
            'id': targ.id,
            'name': targ.name,
            'files': targ.files,
            'conf': targ.configfile,
        })

    def POST():
        '''
        TODO: 全ファイルの情報をとってこようとも思ったけど、プロジェクトがデカくなるとヘヴィな
        '''
        targ = Projects().get(entry_id)[0]
        file_path = request.json['file_path']
        full_path = [_path for _path in targ.full_files_path_as_tree() if _path.endswith(file_path)][0]
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


@app.route('/entry/content/<int:entry_id>', methods=['POST', 'PUT', 'DELETE'])
def content(entry_id):
    '''
    TODO: 認証機能をつけたらここは認証必須にする？
    require parameters
    .. highlight:: json
        {
            'file_path': '',
            'content': ''
        }
    '''
    request_params = request.json
    content = Content(entry_id, request_params['file_path'])

    def POST():
        ''' edit contents in file '''
        return content.edit(request_params['content'])

    def PUT():
        ''' add new file in project '''
        return content.create(request_params['content'])

    def DELETE():
        ''' delete file in project '''

    if request.method == 'POST':
        return POST()
    elif request.method == 'PUT':
        return PUT()
    elif request.method == 'DELETE':
        return DELETE()


@app.route('/entry/<int:entry_id>/image', methods=['POST', 'DELETE'])
def image(entry_id):
    request_params = request.json
    image64_as_url = request_params['content']
    image_filename = request_params['image_name']

    def POST():
        return make_image(entry_id).create(image64_as_url, image_filename)

    if request.method == 'POST':
        return POST()


if __name__ == "__main__":
    import sys
    reload(sys)
    sys.setdefaultencoding('utf-8')
    app.debug = True  # enable debug while developping
    app.run()
