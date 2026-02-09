    # ------------------------------------------
    # GIỚI HẠN XUẤT FILE ĐỒNG THỜI
    # ------------------------------------------

    Scenario: Không cho phép xuất file mới khi file trước đang được xử lý
      Given người dùng đã yêu cầu xuất báo cáo ra file
      And hệ thống đang xử lý yêu cầu xuất file
      When người dùng yêu cầu xuất báo cáo ra file lần thứ hai
      Then hệ thống từ chối yêu cầu xuất file mới
      And hệ thống hiển thị thông báo "Vui lòng đợi file xuất hiện tại hoàn tất"
