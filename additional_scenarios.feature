    # ------------------------------------------
    # XEM CHI TIẾT HÓA ĐƠN TỪ BÁO CÁO
    # ------------------------------------------

    Scenario: Xem chi tiết hóa đơn từ danh sách báo cáo
      Given người dùng đang xem danh sách hóa đơn trên báo cáo
      When người dùng chọn xem chi tiết hóa đơn "HD000001"
      Then hệ thống chuyển hướng đến màn hình chi tiết hóa đơn "HD000001"
      And màn hình chi tiết ẩn nút "Lập mới"
      And màn hình chi tiết ẩn nút "Xử lý hóa đơn"

    # ------------------------------------------
    # HIỂN THỊ HÓA ĐƠN THEO TỜ KHAI
    # ------------------------------------------

    Scenario: Báo cáo hiển thị tất cả loại hóa đơn đã đăng ký được CQT chấp nhận
      Given người dùng đã đăng ký 3 tờ khai với CQT
      And tờ khai 1 có hình thức "Hóa đơn điện tử có mã" đã được CQT chấp nhận
      And tờ khai 2 có hình thức "Hóa đơn điện tử không mã" đã được CQT chấp nhận
      And tờ khai 3 có hình thức "Hóa đơn máy tính tiền" đang chờ CQT xét duyệt
      When người dùng xem báo cáo
      Then hệ thống hiển thị hóa đơn thuộc tờ khai 1
      And hệ thống hiển thị hóa đơn thuộc tờ khai 2
      And hệ thống không hiển thị hóa đơn thuộc tờ khai 3

    Scenario: Bộ lọc hình thức hóa đơn chỉ hiển thị hình thức từ tờ khai được CQT chấp nhận
      Given người dùng đã đăng ký các tờ khai với CQT như sau:
        | Hình thức hóa đơn           | Trạng thái tờ khai     |
        | Hóa đơn điện tử có mã       | CQT chấp nhận          |
        | Hóa đơn điện tử không mã    | CQT chấp nhận          |
        | Hóa đơn máy tính tiền       | Đang chờ xét duyệt     |
        | Hóa đơn tự in               | CQT từ chối            |
      When người dùng mở bộ lọc hình thức hóa đơn
      Then hệ thống hiển thị các giá trị sau:
        | Hình thức hóa đơn           |
        | Hóa đơn điện tử có mã       |
        | Hóa đơn điện tử không mã    |
      And hệ thống không hiển thị "Hóa đơn máy tính tiền"
      And hệ thống không hiển thị "Hóa đơn tự in"

    # ------------------------------------------
    # FORMAT SỐ THẬP PHÂN
    # ------------------------------------------

    Scenario: Hiển thị số thập phân theo định dạng của hóa đơn
      Given hóa đơn "HD001" có số thập phân được cấu hình là 2 chữ số
      And hóa đơn "HD001" có đơn giá "100000.5"
      When người dùng xem báo cáo
      Then hệ thống hiển thị đơn giá của "HD001" là "100,000.50"

    Scenario: Format số thập phân khác nhau giữa các hóa đơn
      Given hóa đơn "HD001" có cấu hình số thập phân là 2 chữ số
      And hóa đơn "HD002" có cấu hình số thập phân là 4 chữ số
      And hóa đơn "HD001" có tổng tiền "1500000.5"
      And hóa đơn "HD002" có tổng tiền "2500000.123"
      When người dùng xem báo cáo
      Then hệ thống hiển thị tổng tiền "HD001" là "1,500,000.50"
      And hệ thống hiển thị tổng tiền "HD002" là "2,500,000.1230"

    Scenario Outline: Áp dụng format số thập phân cho tất cả trường tiền tệ
      Given hóa đơn có cấu hình số thập phân là <số_thập_phân> chữ số
      And hóa đơn có giá trị "<giá_trị_gốc>"
      When người dùng xem báo cáo
      Then hệ thống hiển thị giá trị là "<giá_trị_hiển_thị>"

      Examples:
        | số_thập_phân | giá_trị_gốc  | giá_trị_hiển_thị |
        | 0            | 100000       | 100,000          |
        | 2            | 100000.5     | 100,000.50       |
        | 4            | 100000.123   | 100,000.1230     |
        | 2            | 999999.999   | 1,000,000.00     |

    Scenario: Format số thập phân áp dụng cho file xuất báo cáo
      Given hóa đơn trong báo cáo có cấu hình số thập phân là 2 chữ số
      When người dùng xuất báo cáo ra file
      Then tất cả giá trị tiền tệ trong file được format với 2 chữ số thập phân
      And dấu phân cách hàng nghìn được áp dụng đúng chuẩn
