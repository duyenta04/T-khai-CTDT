    # ------------------------------------------
    # LÀM RÕ: NGÀY HÓA ĐƠN LÀ NGÀY XUẤT HÓA ĐƠN
    # ------------------------------------------

    Scenario: Ngày hóa đơn hiển thị trên báo cáo là ngày xuất hóa đơn
      Given người dùng tạo hóa đơn "HD001" ngày 10/12/2025 ở trạng thái nháp
      When người dùng xuất hóa đơn "HD001" ngày 15/12/2025
      And người dùng xem báo cáo
      Then hệ thống hiển thị ngày hóa đơn "HD001" là 15/12/2025

    Scenario: Bộ lọc thời gian sử dụng ngày xuất hóa đơn để lọc
      Given người dùng tạo hóa đơn "HD001" ngày 28/11/2025
      And người dùng xuất hóa đơn "HD001" ngày 05/12/2025
      When người dùng lọc báo cáo theo kỳ "Tháng 12/2025"
      Then hệ thống hiển thị hóa đơn "HD001"
      When người dùng lọc báo cáo theo kỳ "Tháng 11/2025"
      Then hệ thống không hiển thị hóa đơn "HD001"

    Scenario: Hóa đơn nháp chưa xuất không hiển thị trong báo cáo
      Given người dùng tạo hóa đơn "HD001" ngày 10/12/2025 ở trạng thái nháp
      But hóa đơn "HD001" chưa được xuất
      When người dùng lọc báo cáo theo kỳ "Tháng 12/2025"
      Then hệ thống không hiển thị hóa đơn "HD001"
