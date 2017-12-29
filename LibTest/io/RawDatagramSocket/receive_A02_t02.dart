/*
 * Copyright (c) 2017, the Dart project authors.  Please see the AUTHORS file
 * for details. All rights reserved. Use of this source code is governed by a
 * BSD-style license that can be found in the LICENSE file.
 */
/**
 * @assertion Datagram receive()
 * Receive a datagram.
 * . . .
 * The maximum length of the datagram that can be received is 65503 bytes.
 *
 * @description Checks that the 65508 bytes datagram can not be received.
 * @author ngl@unipro.ru
 */
import "dart:async";
import "dart:io";
import "../../../Utils/expect.dart";
import "../../../Utils/async_utils.dart";

int sentLength = 65508;

main() {
  asyncStart();
  var address = InternetAddress.LOOPBACK_IP_V4;
  RawDatagramSocket.bind(address, 0).then((producer) {
    RawDatagramSocket.bind(address, 0).then((receiver) {
      Timer timer2;
      int received = 0;
      List<int> sList = new List<int>(sentLength);
      for (int i = 0; i < sentLength; i++) {
        sList[i] = i & 0xff;
      }

      List<List<int>> sentLists = [[1], sList, [2, 3]];

      producer.send(sentLists[0], address, receiver.port);
      producer.send(sentLists[1], address, receiver.port);
      producer.send(sentLists[2], address, receiver.port);
      producer.close();

      void action() {
        Expect.equals(3, received);
        asyncEnd();
      }

      List<int> rList;
      int longDataLength = 0;
      receiver.listen((event) {
        received++;
        if (event == RawSocketEvent.CLOSED) {
          if (longDataLength == sentLength) {
            Expect.fail('Long datagram was received: length $longDataLength');
          }
        }
        var datagram = receiver.receive();
        if (datagram != null) {
          rList = datagram.data;
          if (rList.length == sList.length) {
            longDataLength = rList.length;
          }
        }
        if (timer2 != null) timer2.cancel();
        timer2 = new Timer(const Duration(milliseconds: 200), () {
          Expect.isNull(receiver.receive());
          receiver.close();
        });
      }, onError: (error) {
        Expect.isTrue(error is StateError);
      }).onDone(action);
    });
  });
}