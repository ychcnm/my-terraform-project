require 'serverspec'

set :backend, :ssh
set :host, '47.129.204.143'  # 你的目标 IP

# 修改这里：使用 ec2-user 而不是 ychcn
set :ssh_options, {
  user: 'ec2-user',  # 这是 Amazon Linux 的正确用户名
  auth_methods: ['publickey'],
  keys: [File.expand_path('../../keys/terra-test.ppk', __FILE__)],
  paranoid: false,   # 禁用主机密钥检查
  verbose: :debug    # 启用详细日志
}