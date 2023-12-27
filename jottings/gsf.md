# Gsf

## 备注

### 解决：`zmq4.go:1167:34: could not determine kind of name for C.zmq_msg_group`

```bash
git clone https://github.com/zeromq/libzmq.git
cd libzmq && git checkout v4.3.5
./autogen.sh && ./configure && make && make install
cp /usr/local/lib/libzmq.so* /lib/x86_64-linux-gnu/
```
