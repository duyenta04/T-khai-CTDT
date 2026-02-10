    # ------------------------------------------
    # LỌC THEO TRẠNG THÁI BIÊN BẢN
    # ------------------------------------------

    Scenario: Hiển thị bộ lọc trạng thái biên bản khi chọn hóa đơn bị điều chỉnh
      Given người dùng đang xem báo cáo
      When người dùng lọc theo tính chất "Hóa đơn bị điều chỉnh"
      Then hệ thống hiển thị bộ lọc con "Trạng thái biên bản"
      And bộ lọc "Trạng thái biên bản" có các giá trị:
        | Trạng thái biên bản |
        | Đã lập biên bản     |
        | Chưa lập biên bản   |

    Scenario: Lọc hóa đơn bị điều chỉnh theo trạng thái biên bản
      Given người dùng có 10 hóa đơn bị điều chỉnh
      And 6 hóa đơn đã lập biên bản
      And 4 hóa đơn chưa lập biên bản
      When người dùng lọc theo tính chất "Hóa đơn bị điều chỉnh"
      And người dùng lọc thêm theo trạng thái biên bản "Đã lập biên bản"
      Then hệ thống chỉ hiển thị 6 hóa đơn đã lập biên bản

    Scenario: Ẩn bộ lọc trạng thái biên bản khi chọn tính chất hóa đơn khác
      Given người dùng đang lọc theo tính chất "Hóa đơn bị điều chỉnh"
      And bộ lọc "Trạng thái biên bản" đang hiển thị
      When người dùng chuyển sang lọc theo tính chất "Hóa đơn gốc"
      Then hệ thống ẩn bộ lọc "Trạng thái biên bản"
      And hệ thống xóa điều kiện lọc trạng thái biên bản đã chọn trước đó
