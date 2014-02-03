# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


import subprocess

from env import (PROJECTS_ROOT, PATH_TO_PROJECT, )


class BuildTask(object):
    def __init__(self):
        assert self.task

    def exe(self, target_project_name):
        '''
        :rtype: tuple of str
        :return: (std_output, std_err)
        '''
        # make_mainを呼び出そうかと考えたが、それだと初期設定の反映のためにMakefileの
        # パースが必要になるのでやめた。
        # from sphinx import main, make_main
        p = subprocess.Popen(
            'cd {0}/{1}/{2}; make {3}'.format(
                PROJECTS_ROOT,
                PATH_TO_PROJECT,
                target_project_name,
                self.task,
            ),
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            shell=True
        )
        out = p.stdout.read()
        err = p.stderr.read()
        return (out, err)


class BuildHtml(BuildTask):
    def __init__(self):
        self.task = 'html'


html = BuildHtml()
