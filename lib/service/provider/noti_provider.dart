class NotiProvider {
  getNotiList() async {
    return {
      "data": [
        {
          "id": 1,
          "title": "알림1",
          "content": "알림1 내용",
          "createdAt": "2021-08-01 00:00:00",
        },
        {
          "id": 2,
          "title": "알림2",
          "content": "알림2 내용",
          "createdAt": "2021-08-02 00:00:00",
        },
        {
          "id": 3,
          "title": "알림3",
          "content": "알림3 내용",
          "createdAt": "2021-08-03 00:00:00",
        },
      ],
    };
  }
}
