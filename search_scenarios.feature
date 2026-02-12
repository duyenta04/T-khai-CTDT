    # ------------------------------------------
    # TÌM KIẾM NHANH BẰNG THANH SEARCH
    # ------------------------------------------

    Scenario: Tìm kiếm hóa đơn theo số hóa đơn
      Given người dùng có 50 hóa đơn trong báo cáo
      And có hóa đơn số "HD000123"
      When người dùng nhập "HD000123" vào thanh tìm kiếm
      Then hệ thống hiển thị hóa đơn có số "HD000123"
      And hệ thống ẩn các hóa đơn khác

    Scenario: Tìm kiếm hóa đơn theo mã số thuế khách hàng
      Given người dùng có 50 hóa đơn trong báo cáo
      And có 3 hóa đơn của khách hàng có MST "0123456789"
      When người dùng nhập "0123456789" vào thanh tìm kiếm
      Then hệ thống hiển thị 3 hóa đơn có MST khách hàng "0123456789"

    Scenario: Tìm kiếm hóa đơn theo tên khách hàng
      Given người dùng có 50 hóa đơn trong báo cáo
      And có 5 hóa đơn của khách hàng "Công ty TNHH ABC"
      When người dùng nhập "Công ty TNHH ABC" vào thanh tìm kiếm
      Then hệ thống hiển thị 5 hóa đơn của khách hàng "Công ty TNHH ABC"

    Scenario: Tìm kiếm không phân biệt hoa thường với tên khách hàng
      Given người dùng có hóa đơn của khách hàng "Công ty TNHH ABC"
      When người dùng nhập "công ty tnhh abc" vào thanh tìm kiếm
      Then hệ thống hiển thị hóa đơn của khách hàng "Công ty TNHH ABC"

    Scenario: Tìm kiếm với từ khóa một phần của tên khách hàng
      Given người dùng có các hóa đơn của khách hàng sau:
        | Tên khách hàng              |
        | Công ty TNHH ABC            |
        | Công ty TNHH XYZ            |
        | Công ty Cổ phần ABC Tech    |
      When người dùng nhập "ABC" vào thanh tìm kiếm
      Then hệ thống hiển thị 2 hóa đơn có tên khách hàng chứa "ABC"

    Scenario: Hiển thị thông báo khi không tìm thấy kết quả
      Given người dùng có 50 hóa đơn trong báo cáo
      When người dùng nhập "KHONGTONTAI123" vào thanh tìm kiếm
      Then hệ thống hiển thị thông báo không tìm thấy kết quả
      And hệ thống không hiển thị hóa đơn nào

    Scenario: Xóa từ khóa tìm kiếm để hiển thị lại toàn bộ danh sách
      Given người dùng đã tìm kiếm và có 3 hóa đơn hiển thị
      When người dùng xóa từ khóa trong thanh tìm kiếm
      Then hệ thống hiển thị lại toàn bộ danh sách hóa đơn theo bộ lọc hiện tại

    Scenario: Kết hợp tìm kiếm với bộ lọc
      Given người dùng đã lọc theo ký hiệu "1C25TSA" còn 20 hóa đơn
      When người dùng nhập "0123456789" vào thanh tìm kiếm
      Then hệ thống chỉ hiển thị hóa đơn có ký hiệu "1C25TSA" và MST "0123456789"
