import neovim
import os

@neovim.plugin
class PythonEnvPlugin(object):
    def __init__(self, vim):
        self.vim = vim

    @neovim.command('EnablePythonEnv', nargs=1)
    def enable_python_env(self, args):
        env_name = args[0]
        env_path = os.path.abspath(env_name)
        self.vim.command('let g:python3_host_prog="' + env_path + '/bin/python"')
        self.vim.command('let g:python_host_prog="' + env_path + '/bin/python"')
        self.vim.out_write('Enabled Python environment: {}\n'.format(env_name))

    @neovim.command('DisablePythonEnv')
    def disable_python_env(self):
        self.vim.command('let g:python3_host_prog=""')
        self.vim.command('let g:python_host_prog=""')
        self.vim.out_write('Disabled Python environment\n')

    @neovim.command('ListPythonEnvs')
    def list_python_envs(self):
        envs = [env for env in os.listdir('.') if os.path.isdir(env) and 'bin/python' in os.listdir(env)]
        if envs:
            self.vim.out_write('Python environments:\n')
            for env in envs:
                self.vim.out_write('- {}\n'.format(env))
        else:
            self.vim.out_write('No Python environments found\n')
