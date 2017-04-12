import socket
import threading
import time
import struct


share_data=[]


def tcplink(sock, addr):
    global share_data
    print('Accept new connection from %s:%s...' % addr)
    lock = threading.Lock()
    while True:
        if addr[0] == '127.0.0.1':
            lock.acquire()
            sock.send(struct.pack('unsigned short',share_data))
            share_data = []
            lock.release()
        else:
            temp = sock.recv(1024)
            lock.acquire()
            share_data = struct.unpack('unsigned short',temp)
            lock.release()
            print('%d\n',share_data)
        time.sleep(0.1)
    sock.close()
    print('Connection from %s:%s closed.' % addr)


def main():
    serverPort = 55000
    dataserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    dataserver.bind(('0.0.0.0', serverPort))
    # waiting maximum three connections
    dataserver.listen(2)
    print('Waiting for connection...')
    while True:
        # 接受一个新连接:
        sock, addr = dataserver.accept()
        # 创建新线程来处理TCP连接:
        t = threading.Thread(target=tcplink, args=(sock, addr))
        t.start()


if __name__ == "__main__":
    main()
