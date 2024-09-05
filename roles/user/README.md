# generate password

```sh
ansible -i localhost, all -m debug  -a "msg={{ 'mKuM#8V4' | password_hash('sha512') }}"
```
