import socket
import threading
import time


def tcplink(sock, addr, share_data):
    print('Accept new connection from %s:%s...' % addr)
    lock = threading.Lock()
    while True:
        if addr[0] == '127.0.0.1':
            lock.acquire()
            sock.send(bytes(share_data, 'UTF-8'))
            lock.release()
        else:
            lock.acquire()
            share_data = sock.recv(1024)
            if share_data == 'exit' or not share_data:
                break
            lock.release()
        time.sleep(0.1)
    sock.close()
    print('Connection from %s:%s closed.' % addr)


def main():
    serverPort = 55000
    sampleRate = 250
    bufferSize = 3 * sampleRate  # in seconds
    updateInterval = 0.04
    share_data = '12345'
    dataserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    dataserver.bind(('0.0.0.0', serverPort))
    # waiting maximum three connections
    dataserver.listen(3)
    print('Waiting for connection...')
    while True:
        # 接受一个新连接:
        sock, addr = dataserver.accept()
        # 创建新线程来处理TCP连接:
        t = threading.Thread(target=tcplink, args=(sock, addr, share_data))
        t.start()


if __name__ == "__main__":
    main()
