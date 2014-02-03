# -*- coding: utf-8 -*-
from __future__ import (print_function, division, absolute_import, unicode_literals, )


from env import (PROJECTS_ROOT, PATH_TO_PROJECT, )
from models.project import Projects
from .operator import html


def build(project_id, task=html):
    '''
    :param BuildTask task: task to build sphinx
    :rtype: tuple of str
    :return: (std_output, std_err)
    '''
    target_project = Projects().get(project_id)
    return task.exe(target_project[0].name)
