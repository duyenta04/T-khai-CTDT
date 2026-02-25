Feature: Báo cáo hóa đơn điện tử

  Là người dùng KV Einvoice
  Tôi muốn xem các báo cáo hóa đơn với khả năng lọc dữ liệu
  Để theo dõi và quản lý hóa đơn theo nhu cầu

  Background:
    Given người dùng "ABC Company" đã phát hành các hóa đơn trong tháng 12/2025
    And người dùng "John" có quyền xem báo cáo

  # ============================================
  # RULE: PHÂN QUYỀN
  # ============================================

  Rule: Người dùng cần có quyền tương ứng để truy cập từng loại báo cáo

    Scenario Outline: Người dùng có quyền truy cập báo cáo
      Given người dùng "John" có quyền "<quyền>"
      When người dùng "John" truy cập "<loại_báo_cáo>"
      Then hệ thống hiển thị danh sách hóa đơn

      Examples:
        | loại_báo_cáo                         | quyền                                         |
        | Bảng kê tổng hợp                     | Báo cáo - Bảng kê tổng hợp                    |
        | Bảng kê hóa đơn thay thế             | Báo cáo - Bảng kê hóa đơn thay thế            |
        | Bảng kê hóa đơn điều chỉnh           | Báo cáo - Bảng kê hóa đơn điều chỉnh          |
        | Bảng kê hóa đơn lập thông báo sai sót| Báo cáo - Bảng kê hóa đơn lập thông báo sai sót|

    Scenario: Người dùng không có quyền truy cập báo cáo
      Given người dùng "Jane" không có quyền "Báo cáo - Bảng kê tổng hợp"
      When người dùng "Jane" truy cập "Bảng kê tổng hợp"
      Then hệ thống hiển thị thông báo không có quyền truy cập

    Scenario Outline: Người dùng không có quyền truy cập các báo cáo khác
      Given người dùng "Jane" không có quyền "<quyền>"
      When người dùng "Jane" truy cập "<loại_báo_cáo>"
      Then hệ thống hiển thị thông báo không có quyền truy cập

      Examples:
        | loại_báo_cáo                         | quyền                                         |
        | Bảng kê hóa đơn thay thế             | Báo cáo - Bảng kê hóa đơn thay thế            |
        | Bảng kê hóa đơn điều chỉnh           | Báo cáo - Bảng kê hóa đơn điều chỉnh          |
        | Bảng kê hóa đơn lập thông báo sai sót| Báo cáo - Bảng kê hóa đơn lập thông báo sai sót|

  # ============================================
  # RULE: BỘ LỌC CHUNG CHO CÁC BÁO CÁO
  # ============================================

  Rule: Các báo cáo có bộ lọc chung với logic xử lý giống nhau

    Background:
      Given người dùng đang xem một báo cáo hóa đơn

    # ------------------------------------------
    # LỌC THEO THỜI GIAN - KỲ XUẤT HÓA ĐƠN
    # ------------------------------------------

    Scenario Outline: Lọc hóa đơn theo khoảng thời gian
      Given người dùng đã phát hành các hóa đơn trong năm 2025
      When người dùng lọc từ "<từ_ngày>" đến "<đến_ngày>"
      Then hệ thống chỉ hiển thị các hóa đơn có ngày xuất hóa đơn từ "<từ_ngày>" đến "<đến_ngày>"

      Examples:
        | Kỳ              | từ_ngày    | đến_ngày   |
        | Quý 4/2025      | 01/10/2025 | 31/12/2025 |
        | Tháng 12/2025   | 01/12/2025 | 31/12/2025 |
        | Tùy chỉnh       | 15/12/2025 | 20/12/2025 |
    
    Scenario: Ngày hóa đơn hiển thị trên báo cáo là ngày xuất hóa đơn
      Given người dùng tạo hóa đơn "HD001" ngày 10/12/2025 ở trạng thái nháp
      When người dùng xuất hóa đơn "HD001" ngày 15/12/2025
      And người dùng xem báo cáo
      Then hệ thống hiển thị ngày hóa đơn "HD001" là 15/12/2025

    Scenario: Bộ lọc Kỳ xuất hóa đơn sử dụng ngày xuất hóa đơn để lọc
      Given người dùng tạo hóa đơn "HD001" ngày 28/11/2025
      And người dùng xuất hóa đơn "HD001" ngày 05/12/2025
      When người dùng lọc báo cáo theo kỳ xuất hóa đơn "Tháng 12/2025"
      Then hệ thống hiển thị hóa đơn "HD001"
      When người dùng lọc báo cáo theo kỳ xuất hóa đơn "Tháng 11/2025"
      Then hệ thống không hiển thị hóa đơn "HD001"

    # ------------------------------------------
    # LỌC THEO KÝ HIỆU HÓA ĐƠN
    # ------------------------------------------

    Scenario: Lọc hóa đơn theo ký hiệu hóa đơn
      Given người dùng có 3 ký hiệu hóa đơn: "1C25TSA", "2C25TSA", "3C25TSA"
      And ký hiệu "1C25TSA" có 10 hóa đơn
      And ký hiệu "2C25TSA" có 5 hóa đơn
      When người dùng lọc theo ký hiệu "1C25TSA"
      Then hệ thống chỉ hiển thị 10 hóa đơn có ký hiệu "1C25TSA"

    # ------------------------------------------
    # LỌC THEO NGÀY HÓA ĐƠN
    # ------------------------------------------

    Scenario: Lọc hóa đơn theo ngày hóa đơn
      Given người dùng đã phát hành 5 hóa đơn ngày 19/12/2025
      And đã phát hành 3 hóa đơn ngày 20/12/2025
      When người dùng lọc theo ngày hóa đơn "19/12/2025"
      Then hệ thống chỉ hiển thị 5 hóa đơn có ngày "19/12/2025"

    # ------------------------------------------
    # LỌC THEO TÍNH CHẤT HÓA ĐƠN
    # ------------------------------------------

    Scenario Outline: Lọc hóa đơn theo tính chất hóa đơn
      Given người dùng đã phát hành các loại hóa đơn khác nhau
      When người dùng lọc theo tính chất "<tính_chất>"
      Then hệ thống chỉ hiển thị các hóa đơn có tính chất "<tính_chất>"

      Examples:
        | tính_chất                      |
        | Hóa đơn gốc                    |
        | Hóa đơn bị thay thế            |
        | Hóa đơn thay thế               |
        | Hóa đơn bị điều chỉnh          |
        | Hóa đơn điều chỉnh             |

    # ------------------------------------------
    # LỌC THEO TRẠNG THÁI BIÊN BẢN
    # ------------------------------------------

    Scenario Outline: Hiển thị bộ lọc trạng thái biên bản khi chọn hóa đơn điều chỉnh hoặc thay thế
      Given người dùng đang xem báo cáo
      When người dùng lọc theo tính chất "<tính_chất>"
      Then hệ thống hiển thị bộ lọc con "Trạng thái biên bản"
      And bộ lọc "Trạng thái biên bản" có các giá trị:
        | Trạng thái biên bản |
        | Đã lập biên bản     |
        | Chưa lập biên bản   |

      Examples:
        | tính_chất              |
        | Hóa đơn điều chỉnh     |
        | Hóa đơn thay thế       |

    Scenario: Lọc hóa đơn điều chỉnh theo trạng thái biên bản
      Given người dùng có 10 hóa đơn điều chỉnh
      And 6 hóa đơn đã lập biên bản
      And 4 hóa đơn chưa lập biên bản
      When người dùng lọc theo tính chất "Hóa đơn điều chỉnh"
      And người dùng lọc thêm theo trạng thái biên bản "Đã lập biên bản"
      Then hệ thống chỉ hiển thị 6 hóa đơn đã lập biên bản

    Scenario: Lọc hóa đơn thay thế theo trạng thái biên bản
      Given người dùng có 8 hóa đơn thay thế
      And 5 hóa đơn đã lập biên bản
      And 3 hóa đơn chưa lập biên bản
      When người dùng lọc theo tính chất "Hóa đơn thay thế"
      And người dùng lọc thêm theo trạng thái biên bản "Chưa lập biên bản"
      Then hệ thống chỉ hiển thị 3 hóa đơn chưa lập biên bản

    Scenario: Ẩn bộ lọc trạng thái biên bản khi chọn tính chất hóa đơn khác
      Given người dùng đang lọc theo tính chất "Hóa đơn điều chỉnh"
      And bộ lọc "Trạng thái biên bản" đang hiển thị
      When người dùng chuyển sang lọc theo tính chất "Hóa đơn gốc"
      Then hệ thống ẩn bộ lọc "Trạng thái biên bản"
      And hệ thống xóa điều kiện lọc trạng thái biên bản đã chọn trước đó
      
    # ------------------------------------------
    # LỌC THEO TRẠNG THÁI CQT
    # ------------------------------------------

    Scenario Outline: Lọc hóa đơn theo trạng thái CQT - Hóa đơn máy tính tiền
      Given người dùng có tờ khai đăng ký "Hóa đơn máy tính tiền" đã được CQT chấp nhận
      And hệ thống có hóa đơn máy tính tiền ở các trạng thái khác nhau
      When người dùng lọc theo trạng thái CQT "<trạng_thái>"
      Then hệ thống chỉ hiển thị các hóa đơn máy tính tiền có trạng thái "<trạng_thái>"

      Examples:
        | trạng_thái                |
        | Chưa gửi CQT              |
        | Lỗi gửi hóa đơn cho CQT  |
        | Đã gửi CQT                |
        | CQT đã tiếp nhận          |
        | CQT kiểm tra không hợp lệ |

    Scenario Outline: Lọc hóa đơn theo trạng thái CQT - Hóa đơn thường có mã
      Given người dùng có tờ khai đăng ký "Hóa đơn thường có mã CQT" đã được CQT chấp nhận
      And hệ thống có hóa đơn thường có mã ở các trạng thái khác nhau
      When người dùng lọc theo trạng thái CQT "<trạng_thái>"
      Then hệ thống chỉ hiển thị các hóa đơn thường có mã với trạng thái "<trạng_thái>"

      Examples:
        | trạng_thái                |
        | Phát hành lỗi             |
        | Đã phát hành              |
        | CQT đã cấp mã             |
        | Không đủ điều kiện cấp mã |

    Scenario Outline: Lọc hóa đơn theo trạng thái CQT - Hóa đơn thường không mã
      Given người dùng có tờ khai đăng ký "Hóa đơn thường không mã CQT" đã được CQT chấp nhận
      And hệ thống có hóa đơn thường không mã ở các trạng thái khác nhau
      When người dùng lọc theo trạng thái CQT "<trạng_thái>"
      Then hệ thống chỉ hiển thị các hóa đơn thường không mã với trạng thái "<trạng_thái>"

      Examples:
        | trạng_thái                |
        | Phát hành lỗi             |
        | Đã phát hành              |
        | CQT đã tiếp nhận          |
        | CQT kiểm tra không hợp lệ |

    Scenario Outline: Hiển thị đúng nhóm trạng thái CQT theo loại hóa đơn đăng ký đơn lẻ
      Given người dùng có tờ khai đăng ký "<loại_hóa_đơn_sử_dụng>" đã được CQT chấp nhận
      When người dùng mở bộ lọc trạng thái CQT
      Then hệ thống chỉ hiển thị nhóm trạng thái tương ứng với "<loại_hóa_đơn_sử_dụng>"
      And hệ thống không hiển thị nhóm trạng thái của loại hóa đơn chưa đăng ký

      Examples:
        | loại_hóa_đơn_sử_dụng      |
        | Hóa đơn máy tính tiền     |
        | Hóa đơn thường có mã      |
        | Hóa đơn thường không mã   |

    Scenario Outline: Hiển thị gộp các nhóm trạng thái CQT khi đăng ký nhiều loại hóa đơn
      Given người dùng có tờ khai đăng ký "<loại_hóa_đơn_sử_dụng>" đã được CQT chấp nhận
      When người dùng mở bộ lọc trạng thái CQT
      Then hệ thống hiển thị gộp các nhóm trạng thái tương ứng với từng loại đã đăng ký

      Examples:
        | loại_hóa_đơn_sử_dụng                                                         |
        | Hóa đơn máy tính tiền, Hóa đơn thường có mã                                  |
        | Hóa đơn máy tính tiền, Hóa đơn thường không mã                               |
        | Hóa đơn thường có mã, Hóa đơn thường không mã                                |
        | Hóa đơn máy tính tiền, Hóa đơn thường có mã, Hóa đơn thường không mã        |

    Scenario: Không hiển thị bộ lọc trạng thái CQT khi chưa có tờ khai được CQT chấp nhận
      Given người dùng chưa có tờ khai đăng ký nào được CQT chấp nhận
      When người dùng mở bộ lọc danh sách hóa đơn
      Then hệ thống không hiển thị bộ lọc trạng thái CQT
        
    # ------------------------------------------
    # LỌC THEO HÌNH THỨC HÓA ĐƠN
    # ------------------------------------------

    Scenario Outline: Lọc hóa đơn theo hình thức hóa đơn
      Given người dùng đã phát hành các hình thức hóa đơn khác nhau
      When người dùng lọc theo hình thức "<hình_thức>"
      Then hệ thống chỉ hiển thị các hóa đơn thuộc hình thức "<hình_thức>"

      Examples:
        | hình_thức                      |
        | Có mã CQT                      |
        | Không mã CQT                   |
        | Hóa đơn từ máy tính tiền       |
      
    Scenario: Bộ lọc hình thức hóa đơn chỉ hiển thị hình thức từ tờ khai được CQT chấp nhận
      Given người dùng đã đăng ký các tờ khai với CQT như sau:
        | Hình thức hóa đơn           | Trạng thái tờ khai     |
        | Hóa đơn điện tử có mã       | CQT chấp nhận          |
        | Hóa đơn điện tử không mã    | CQT từ chối            |
        | Hóa đơn máy tính tiền       | CQT chấp nhận          |
      When người dùng mở bộ lọc hình thức hóa đơn
      Then hệ thống hiển thị các giá trị sau:
        | Hình thức hóa đơn           |
        | Có mã                       |
        | Máy tính tiền               |
      And hệ thống không hiển thị Hình thức hóa đơn "Không mã"

    # ------------------------------------------
    # LỌC THEO TRẠNG THÁI THÔNG BÁO SAI SÓT (TBSS)
    # ------------------------------------------

    Scenario Outline: Lọc hóa đơn theo trạng thái thông báo sai sót
      Given người dùng đã gửi các thông báo sai sót với trạng thái khác nhau
      When người dùng lọc theo trạng thái TBSS "<trạng_thái_tbss>"
      Then hệ thống chỉ hiển thị các hóa đơn có trạng thái TBSS "<trạng_thái_tbss>"

      Examples:
        | trạng_thái_tbss                |
        | Đã gửi CQT                     |
        | CQT chấp nhận                  |
        | CQT không chấp nhận            |

    # ------------------------------------------
    # LỌC THEO NGƯỜI TẠO
    # ------------------------------------------

    Scenario: Lọc hóa đơn theo người tạo
      Given người dùng "John" đã tạo 10 hóa đơn
      And người dùng "Jane" đã tạo 5 hóa đơn
      When người dùng lọc theo người tạo "John"
      Then hệ thống chỉ hiển thị 10 hóa đơn do "John" tạo

    # ------------------------------------------
    # KẾT HỢP NHIỀU BỘ LỌC
    # ------------------------------------------

    Scenario: Kết hợp nhiều bộ lọc
      Given người dùng đã phát hành nhiều hóa đơn
      And có 3 hóa đơn với ký hiệu "1C25TSA" do "John" tạo trong tháng 12/2025
      When người dùng lọc theo ký hiệu "1C25TSA"
      And lọc theo người tạo "John"
      And lọc theo kỳ "Tháng 12/2025"
      Then hệ thống chỉ hiển thị 3 hóa đơn thỏa mãn tất cả điều kiện
    
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

    Scenario: Tìm kiếm với giá trị không có trong báo cáo
      Given người dùng có 50 hóa đơn trong báo cáo
      When người dùng nhập "KHONGTONTAI123" vào thanh tìm kiếm
      Then hệ thống không hiển thị hóa đơn nào

    Scenario: Xóa từ khóa tìm kiếm để hiển thị lại toàn bộ danh sách
      Given người dùng đã tìm kiếm và có 3 hóa đơn hiển thị
      When người dùng xóa từ khóa trong thanh tìm kiếm
      Then hệ thống hiển thị lại toàn bộ danh sách hóa đơn theo bộ lọc hiện tại

    Scenario: Kết hợp tìm kiếm với bộ lọc
      Given người dùng đã lọc theo ký hiệu "1C25TSA" còn 20 hóa đơn
      When người dùng nhập "0123456789" vào thanh tìm kiếm
      Then hệ thống chỉ hiển thị hóa đơn có ký hiệu "1C25TSA" và MST "0123456789"
  
    # ------------------------------------------
    # GIỚI HẠN XUẤT FILE ĐỒNG THỜI
    # ------------------------------------------

    Scenario: Hệ thống không hỗ trợ xuất file mới khi file trước đang được xử lý
      Given người dùng đã yêu cầu xuất báo cáo ra file
      And hệ thống đang xử lý yêu cầu xuất file
      When người dùng yêu cầu xuất báo cáo ra file lần thứ hai
      Then hệ thống từ chối yêu cầu xuất file mới
  
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
      Then hệ thống hiển thị hóa đơn điện tử có mã
      And hệ thống hiển thị hóa đơn điện tử không mã
      And hệ thống không hiển thị hóa đơn máy tính tiền

  # ============================================
  # RULE: BẢNG KÊ TỔNG HỢP
  # ============================================

  Rule: Bảng kê tổng hợp hiển thị toàn bộ hóa đơn đã phát hành trong kỳ

    Background:
      Given người dùng có quyền "Báo cáo - Bảng kê tổng hợp"
      And người dùng đang truy cập Bảng kê tổng hợp

    # ------------------------------------------
    # CÁC TRƯỜNG THÔNG TIN
    # ------------------------------------------

    Scenario: Danh sách các trường thông tin hiển thị trên Bảng kê tổng hợp
      Then hệ thống hiển thị các cột sau:
        | Nhóm thông tin              | Tên cột                    |
        | Thông tin định danh         | STT                        |
        | Thông tin định danh         | Ký hiệu                    |
        | Thông tin định danh         | Số hóa đơn                 |
        | Thông tin định danh         | Ngày hóa đơn               |
        | Trạng thái và tính chất     | Tính chất hóa đơn          |
        | Trạng thái và tính chất     | Trạng thái gửi CQT         |
        | Thông tin khách hàng        | Mã khách hàng              |
        | Thông tin khách hàng        | Mã số thuế                 |
        | Thông tin khách hàng        | Tên khách hàng             |
        | Thông tin khách hàng        | Địa chỉ                    |
        | Thông tin khách hàng        | Họ tên người mua           |
        | Thông tin thanh toán        | Hình thức thanh toán       |
        | Thông tin thanh toán        | Loại tiền                  |
        | Thông tin thanh toán        | Tỷ giá                     |
        | Thông tin giá trị           | Tổng tiền hàng             |
        | Thông tin giá trị           | Tiền chiết khấu            |
        | Thông tin giá trị           | Tổng tiền trước thuế       |
        | Thông tin giá trị           | Tiền thuế GTGT             |
        | Thông tin giá trị           | Tổng tiền                  |
        | Thông tin bổ sung           | Ghi chú                    |
        | Thông tin bổ sung           | Người lập                  |
        | Thông tin định danh         | Ngày ký hóa đơn            |

    # ------------------------------------------
    # XEM DANH SÁCH
    # ------------------------------------------

    Scenario: Xem toàn bộ hóa đơn đã phát hành trong kỳ
      Given người dùng đã phát hành 15 hóa đơn trong tháng 12/2025
      And có 2 hóa đơn lỗi gửi
      And có 1 hóa đơn bị từ chối
      When người dùng truy cập Bảng kê tổng hợp với kỳ "Tháng 12/2025"
      Then hệ thống hiển thị đầy đủ 15 hóa đơn
      And danh sách bao gồm cả hóa đơn lỗi gửi
      And danh sách bao gồm cả hóa đơn bị từ chối

    Scenario: Hiển thị thông tin chi tiết của mỗi hóa đơn
      Given hóa đơn "HD001" có các thông tin sau:
        | Thuộc tính                   | Giá trị                        |
        | Ký hiệu                      | 1C25TSA                        |
        | Số hóa đơn                   | HD000001                       |
        | Ngày hóa đơn                 | 19/12/2025                     |
        | Ngày ký hóa đơn              | 19/12/2025                     |
        | Tính chất hóa đơn            | Hóa đơn gốc                    |
        | Trạng thái CQT               | CQT đã tiếp nhận               |
        | Mã khách hàng                | KH001                          |
        | Mã số thuế                   | 001196088999                   |
        | Tên khách hàng               | Công ty TNHH ABC               |
        | Địa chỉ                      | 1A Yết Kiếu                    |
        | Họ tên người mua             | Nguyễn Văn A                   |
        | Hình thức thanh toán         | Tiền mặt                       |
        | Loại tiền                    | VND                            |
        | Tổng tiền hàng               | 10,000,000                     |
        | Tiền chiết khấu              | 0                              |
        | Tổng tiền trước thuế         | 10,000,000                     |
        | Tiền thuế GTGT               | 1,000,000                      |
        | Tổng tiền                    | 11,000,000                     |
        | Người lập                    | John                           |
      When người dùng xem Bảng kê tổng hợp
      Then hệ thống hiển thị đầy đủ thông tin của hóa đơn "HD001"

    # ------------------------------------------
    # BỘ LỌC ÁP DỤNG CHO BẢNG KÊ TỔNG HỢP
    # ------------------------------------------

    Scenario: Danh sách bộ lọc áp dụng cho Bảng kê tổng hợp
      When người dùng mở phần lọc dữ liệu
      Then hệ thống hiển thị các bộ lọc sau:
        | Bộ lọc                         |
        | Thời gian (Kỳ)                 |
        | Ký hiệu                        |
        | Số hóa đơn                     |
        | Ngày hóa đơn                   |
        | Tính chất hóa đơn              |
        | Trạng thái gửi CQT             |
        | Hình thức hóa đơn              |
        | Người tạo                      |

    Scenario: Xuất Bảng kê tổng hợp ra file
      Given người dùng đang xem Bảng kê tổng hợp với 15 hóa đơn
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file chứa đầy đủ 15 hóa đơn
      And file bao gồm tất cả thông tin hiển thị trên báo cáo

    Scenario: Xuất báo cáo sau khi lọc
      Given người dùng đang xem Bảng kê tổng hợp
      And đã lọc theo ký hiệu "1C25TSA" còn 10 hóa đơn
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file chứa 10 hóa đơn đã lọc
      And file không chứa hóa đơn của ký hiệu khác

    Scenario Outline: Quy tắc đặt tên file khi xuất Bảng kê tổng hợp
      Given người dùng đang xem Bảng kê tổng hợp với kỳ "<kỳ>"
      And kỳ có ngày bắt đầu "<từ_ngày>" và ngày kết thúc "<đến_ngày>"
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file với tên "<tên_file>"

      Examples:
        | kỳ              | từ_ngày    | đến_ngày   | tên_file                            |
        | Kỳ này          | 01/01/2026 | 31/03/2026 | BangKeTongHop_01012026-31032026     |
        | Quý 4/2025      | 01/10/2025 | 31/12/2025 | BangKeTongHop_01102025-31122025     |
        | Tháng 12/2025   | 01/12/2025 | 31/12/2025 | BangKeTongHop_01122025-31122025     |
        | Tùy chỉnh       | 15/12/2025 | 20/12/2025 | BangKeTongHop_15122025-20122025     |

    # ------------------------------------------
    # TRƯỜNG HỢP ĐẶC BIỆT
    # ------------------------------------------

    Scenario: Hiển thị thông báo khi không có hóa đơn trong kỳ
      Given người dùng chưa phát hành hóa đơn nào trong tháng 1/2026
      When người dùng truy cập Bảng kê tổng hợp với kỳ "Tháng 1/2026"
      Then hệ thống hiển thị thông báo không có dữ liệu

    Scenario: Hiển thị hóa đơn có ngoại tệ với tỷ giá
      Given hóa đơn "HD002" sử dụng ngoại tệ "USD"
      And có tỷ giá "23,500 VND/USD"
      When người dùng xem Bảng kê tổng hợp
      Then hệ thống hiển thị loại tiền "USD" của hóa đơn "HD002"
      And hiển thị tỷ giá "23,500" tương ứng

    # ------------------------------------------
    # RULE: BẢNG KÊ CHI TIẾT - XUẤT FILE
    # ------------------------------------------

    Scenario: Xuất Bảng kê chi tiết ra file
      Given người dùng đang xem Bảng kê tổng hợp với 20 hóa đơn
      When người dùng xuất file bảng kê chi tiết
      Then hệ thống tạo file chứa đầy đủ các hàng hóa của 20 hóa đơn
      And file bao gồm tất cả các trường thông tin theo file mẫu đã được định nghĩa

    Scenario: Xuất báo cáo sau khi lọc
      Given người dùng đang xem Bảng kê tổng hợp với 20 hóa đơn
      And đã lọc theo ký hiệu "1C25TSA" còn 8 hóa đơn
      When người dùng xuất file bảng kê chi tiết
      Then hệ thống tạo file chứa đầy đủ các hàng hóa của 8 hóa đơn
      And file bao gồm tất cả các trường thông tin theo file mẫu đã được định nghĩa

    Scenario Outline: Quy tắc đặt tên file khi xuất Bảng kê chi tiết
      Given người dùng đang xem Bảng kê chi tiết với kỳ "<kỳ>"
      And kỳ có ngày bắt đầu "<từ_ngày>" và ngày kết thúc "<đến_ngày>"
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file với tên "<tên_file>"

      Examples:
        | kỳ              | từ_ngày    | đến_ngày   | tên_file                            |
        | Kỳ này          | 01/01/2026 | 31/03/2026 | BangKeChiTiet_01012026-31032026     |
        | Quý 4/2025      | 01/10/2025 | 31/12/2025 | BangKeChiTiet_01102025-31122025     |
        | Tháng 12/2025   | 01/12/2025 | 31/12/2025 | BangKeChiTiet_01122025-31122025     |
        | Tùy chỉnh       | 15/12/2025 | 20/12/2025 | BangKeChiTiet_15122025-20122025     |
      
      
    # ------------------------------------------
    # XUẤT FILE
    # ------------------------------------------

    Scenario: Báo cáo chi tiết hiển thị đủ các trường thông tin
      Given nhân viên kế toán xuất báo cáo chi tiết
      When nhân viên kế toán mở file báo cáo
      Then báo cáo hiển thị đúng các cột thông tin
      And hệ thống hiển thị các cột sau:
      
        | Nhóm thông tin              | Tên cột                    |
        | Thông tin định danh         | STT                        |
        | Thông tin định danh         | Ký hiệu                    |
        | Thông tin định danh         | Số hóa đơn                 |
        | Thông tin định danh         | Ngày hóa đơn               |
        | Trạng thái và tính chất     | Tính chất hóa đơn          |
        | Trạng thái và tính chất     | Trạng thái gửi CQT         |
        | Thông tin khách hàng        | Mã khách hàng              |
        | Thông tin khách hàng        | Mã số thuế                 |
        | Thông tin khách hàng        | Tên khách hàng             |
        | Thông tin khách hàng        | Địa chỉ                    |
        | Thông tin khách hàng        | Họ tên người mua           |
        | Thông tin thanh toán        | Hình thức thanh toán       |
        | Thông tin thanh toán        | Loại tiền                  |
        | Thông tin thanh toán        | Tỷ giá                     |
        | Thông tin sản phẩm          | Mã hàng                    |
        | Thông tin sản phẩm          | Tên hàng                   |
        | Thông tin sản phẩm          | Đơn vị tính                |
        | Thông tin sản phẩm          | Số lượng                   |
        | Thông tin sản phẩm          | Đơn giá                    |
        | Thông tin sản phẩm          | Thành tiền                 |
        | Thông tin sản phẩm          | Tỷ lệ chiết khấu           |
        | Thông tin sản phẩm          | Tiền chiết khấu            |
        | Thông tin sản phẩm          | Thuế suất                  |
        | Thông tin sản phẩm          | Tiền thuế GTGT             |
        | Thông tin giá trị           | Tổng tiền                  |
        | Thông tin bổ sung           | Ghi chú                    |
        | Thông tin bổ sung           | Người lập                  |
        | Thông tin định danh         | Ngày ký hóa đơn            |

  # ============================================
  # RULE: BÁO CÁO HÓA ĐƠN THAY THẾ / ĐIỀU CHỈNH
  # ============================================

  Rule: Báo cáo hóa đơn thay thế/điều chỉnh hiển thị 2 tab song song

    Background:
      Given người dùng có quyền xem báo cáo hóa đơn thay thế/điều chỉnh
      And người dùng đang truy cập báo cáo

    # ------------------------------------------
    # CẤU TRÚC 2 TAB
    # ------------------------------------------

    Scenario Outline: Hiển thị 2 tab song song cho báo cáo hóa đơn thay thế/điều chỉnh
      Given người dùng truy cập "<loại_báo_cáo>"
      Then hệ thống hiển thị 2 tab:
        | Tab                           | Mô tả                                                    |
        | <tab_chính>                   | Hiển thị danh sách <loại_hóa_đơn_chính> theo filter      |
        | <tab_bị_tác_động>             | Hiển thị danh sách <loại_hóa_đơn_bị_tác_động> tương ứng |

      Examples:
        | loại_báo_cáo              | tab_chính           | tab_bị_tác_động        | loại_hóa_đơn_chính     | loại_hóa_đơn_bị_tác_động |
        | Báo cáo hóa đơn thay thế  | Hóa đơn thay thế    | Hóa đơn bị thay thế    | hóa đơn thay thế       | hóa đơn bị thay thế      |
        | Báo cáo hóa đơn điều chỉnh| Hóa đơn điều chỉnh  | Hóa đơn bị điều chỉnh  | hóa đơn điều chỉnh     | hóa đơn bị điều chỉnh    |

    # ------------------------------------------
    # CÁC TRƯỜNG THÔNG TIN - TAB CHÍNH
    # ------------------------------------------

    Scenario: Danh sách các trường thông tin trên tab chính (Hóa đơn thay thế/điều chỉnh)
      When người dùng xem tab chính
      Then hệ thống hiển thị các cột sau:
        | Nhóm thông tin              | Tên cột                    |
        | Thông tin định danh         | Ký hiệu                    |
        | Thông tin định danh         | Số hóa đơn                 |
        | Thông tin định danh         | Ngày hóa đơn               |
        | Thông tin khách hàng        | Mã khách hàng              |
        | Thông tin khách hàng        | Mã số thuế                 |
        | Thông tin khách hàng        | Tên khách hàng             |
        | Thông tin khách hàng        | Địa chỉ                    |
        | Thông tin giá trị           | Tổng tiền                  |
        | Trạng thái                  | Trạng thái gửi CQT         |
        | Trạng thái                  | Trạng thái biên bản        |

    # ------------------------------------------
    # CÁC TRƯỜNG THÔNG TIN - TAB BỊ TÁC ĐỘNG
    # ------------------------------------------

    Scenario: Danh sách các trường thông tin trên tab bị tác động (Hóa đơn bị thay thế/điều chỉnh)
      When người dùng xem tab bị tác động
      Then hệ thống hiển thị các cột sau:
        | Nhóm thông tin              | Tên cột                    |
        | Thông tin định danh         | Ký hiệu                    |
        | Thông tin định danh         | Số hóa đơn                 |
        | Thông tin định danh         | Ngày hóa đơn               |
        | Thông tin khách hàng        | Mã khách hàng              |
        | Thông tin khách hàng        | Mã số thuế                 |
        | Thông tin khách hàng        | Tên khách hàng             |
        | Thông tin khách hàng        | Địa chỉ                    |
        | Thông tin giá trị           | Tổng tiền                  |

    # ------------------------------------------
    # LOGIC HIỂN THỊ TƯƠNG ỨNG GIỮA 2 TAB
    # ------------------------------------------

    Scenario Outline: Hiển thị quan hệ 1-1 giữa 2 tab
      Given tab chính có <số_lượng> <loại_hóa_đơn_chính>
      And <loại_hóa_đơn_chính> "<mã_chính>" tác động lên <loại_hóa_đơn_bị_tác_động> "<mã_bị_tác_động>"
      When người dùng xem tab bị tác động
      Then hệ thống hiển thị <loại_hóa_đơn_bị_tác_động> "<mã_bị_tác_động>" tương ứng

      Examples:
        | loại_hóa_đơn_chính     | loại_hóa_đơn_bị_tác_động | số_lượng | mã_chính | mã_bị_tác_động |
        | hóa đơn thay thế       | hóa đơn bị thay thế      | 5        | HD002    | HD001          |
        | hóa đơn điều chỉnh     | hóa đơn bị điều chỉnh    | 3        | HD004    | HD003          |

    Scenario: Số lượng hóa đơn bị tác động tương ứng với số lượng hóa đơn chính đã lọc
      Given người dùng đã lọc tab chính còn 3 hóa đơn
      When người dùng chuyển sang tab bị tác động
      Then hệ thống hiển thị 3 hóa đơn bị tác động tương ứng

    # ------------------------------------------
    # BỘ LỌC ÁP DỤNG
    # ------------------------------------------

    Scenario: Danh sách bộ lọc áp dụng cho báo cáo hóa đơn thay thế/điều chỉnh
      When người dùng mở phần lọc dữ liệu
      Then hệ thống hiển thị các bộ lọc sau:
        | Bộ lọc                         |
        | Thời gian (Kỳ)                 |
        | Hình thức hóa đơn              |
        | Ký hiệu                        |
        | Trạng thái gửi CQT             |

    Scenario: Filter chỉ áp dụng cho tab chính và tự động cập nhật tab bị tác động
      Given tab chính có 10 hóa đơn với nhiều ký hiệu khác nhau
      When người dùng lọc theo ký hiệu "1C25TSA" trên tab chính
      Then tab chính chỉ hiển thị hóa đơn có ký hiệu "1C25TSA"
      And tab bị tác động tự động hiển thị hóa đơn bị tác động tương ứng

    # ------------------------------------------
    # XEM DANH SÁCH
    # ------------------------------------------

    Scenario Outline: Xem danh sách hóa đơn thay thế/điều chỉnh trong kỳ
      Given người dùng đã phát hành <số_lượng> <loại_hóa_đơn> trong tháng 12/2025
      When người dùng truy cập "<loại_báo_cáo>" với kỳ "Tháng 12/2025"
      And xem tab chính
      Then hệ thống hiển thị đầy đủ <số_lượng> <loại_hóa_đơn>

      Examples:
        | loại_báo_cáo              | loại_hóa_đơn         | số_lượng |
        | Báo cáo hóa đơn thay thế  | hóa đơn thay thế     | 5        |
        | Báo cáo hóa đơn điều chỉnh| hóa đơn điều chỉnh   | 3        |

    # ------------------------------------------
    # XUẤT FILE
    # ------------------------------------------
    Scenario: Xuất file cả 2 tab
      Given tab chính có 5 hóa đơn
      And tab bị tác động có 5 hóa đơn tương ứng
      When người dùng xuất toàn bộ báo cáo ra file
      Then hệ thống tạo file 1 sheet tương ứng với 2 tab

    Scenario Outline: Quy tắc đặt tên file khi xuất Báo cáo hóa đơn thay thế/điều chỉnh
      Given người dùng đang xem "<loại_báo_cáo>" với kỳ "<kỳ>"
      And kỳ có ngày bắt đầu "<từ_ngày>" và ngày kết thúc "<đến_ngày>"
      When người dùng xuất toàn bộ báo cáo ra file
      Then hệ thống tạo file với tên "<tên_file>"

      Examples:
        | loại_báo_cáo              | kỳ              | từ_ngày    | đến_ngày   | tên_file                                 |
        | Báo cáo hóa đơn thay thế  | Kỳ này          | 01/01/2026 | 31/03/2026 | BaoCaoHoaDonThayThe_01012026-31032026    |
        | Báo cáo hóa đơn thay thế  | Quý 4/2025      | 01/10/2025 | 31/12/2025 | BaoCaoHoaDonThayThe_01102025-31122025    |
        | Báo cáo hóa đơn điều chỉnh| Kỳ này          | 01/01/2026 | 31/03/2026 | BaoCaoHoaDonDieuChinh_01012026-31032026  |
        | Báo cáo hóa đơn điều chỉnh| Tháng 12/2025   | 01/12/2025 | 31/12/2025 | BaoCaoHoaDonDieuChinh_01122025-31122025  |

    # ------------------------------------------
    # TRƯỜNG HỢP ĐẶC BIỆT
    # ------------------------------------------

    Scenario: Hiển thị thông báo khi không có hóa đơn trong kỳ
      Given người dùng chưa phát hành hóa đơn thay thế/điều chỉnh nào trong tháng 1/2026
      When người dùng truy cập báo cáo với kỳ "Tháng 1/2026"
      Then tab chính hiển thị thông báo không có dữ liệu
      And tab bị tác động hiển thị thông báo không có dữ liệu

    Scenario: Tab bị tác động tự động cập nhật khi filter tab chính
      Given tab chính có 10 hóa đơn
      And tab bị tác động có 10 hóa đơn tương ứng
      When người dùng lọc tab chính theo ký hiệu "1C25TSA" còn 3 hóa đơn
      Then tab bị tác động tự động cập nhật còn 3 hóa đơn tương ứng

  # ============================================
  # RULE: BÁO CÁO HÓA ĐƠN THÔNG BÁO SAI SÓT
  # ============================================

  Rule: Báo cáo hóa đơn thông báo sai sót hiển thị danh sách hóa đơn có thông báo sai sót

    Background:
      Given người dùng có quyền "Báo cáo - Hóa đơn thông báo sai sót"
      And người dùng đang truy cập Báo cáo hóa đơn thông báo sai sót

    # ------------------------------------------
    # CÁC TRƯỜNG THÔNG TIN
    # ------------------------------------------

    Scenario: Danh sách các trường thông tin hiển thị trên Báo cáo hóa đơn thông báo sai sót
      Then hệ thống hiển thị các cột sau:
        | Nhóm thông tin              | Tên cột                    |
        | Thông tin định danh         | Ký hiệu                    |
        | Thông tin định danh         | Số hóa đơn                 |
        | Thông tin định danh         | Ngày hóa đơn               |
        | Trạng thái và tính chất     | Tính chất hóa đơn          |
        | Thông tin khách hàng        | Mã khách hàng              |
        | Thông tin khách hàng        | Mã số thuế                 |
        | Thông tin khách hàng        | Tên khách hàng             |
        | Thông tin khách hàng        | Địa chỉ                    |
        | Thông tin giá trị           | Tổng tiền hàng             |
        | Thông tin giá trị           | Số thông báo               |
        | Thông tin thông báo         | Ngày thông báo             |
        | Thông tin thông báo         | Lý do                      |
        | Thông tin thông báo         | Loại thông báo             |
        | Trạng thái                  | Trạng thái TBSS            |

    # ------------------------------------------
    # XEM DANH SÁCH
    # ------------------------------------------

    Scenario: Xem danh sách hóa đơn có thông báo sai sót trong kỳ
      Given người dùng đã gửi 8 thông báo sai sót trong tháng 12/2025
      When người dùng truy cập Báo cáo hóa đơn thông báo sai sót với kỳ "Tháng 12/2025"
      Then hệ thống hiển thị đầy đủ 8 hóa đơn có thông báo sai sót

    Scenario: Hiển thị thông tin chi tiết của hóa đơn thông báo sai sót
      Given hóa đơn "HD001" có thông báo sai sót với thông tin sau:
        | Thuộc tính                   | Giá trị                        |
        | Ký hiệu                      | 1C25TSA                        |
        | Số hóa đơn                   | HD000001                       |
        | Ngày hóa đơn                 | 19/12/2025                     |
        | Tính chất hóa đơn            | Hóa đơn gốc                    |
        | Mã khách hàng                | KH001                          |
        | Mã số thuế                   | 001196088999                   |
        | Tên khách hàng               | Công ty TNHH ABC               |
        | Địa chỉ                      | 1A Yết Kiếu                    |
        | Tổng tiền hàng               | 20,000,000                     |
        | Số tháng báo                 | 12                             |
        | Ngày thông báo               | 19/12/2025                     |
        | Lý do                        | Text Content                   |
        | Loại thông báo               | Giải trình                     |
        | Trạng thái TBSS              | CQT chấp nhận                  |
      When người dùng xem Báo cáo hóa đơn thông báo sai sót
      Then hệ thống hiển thị đầy đủ thông tin của hóa đơn "HD001"

    Scenario: Một hóa đơn có thể có nhiều thông báo sai sót
      Given hóa đơn "HD001" có 2 thông báo sai sót
      And thông báo 1 có số "TB000001" trạng thái "CQT chấp nhận"
      And thông báo 2 có số "TB000002" trạng thái "Nháp"
      When người dùng xem Báo cáo hóa đơn thông báo sai sót
      Then hệ thống hiển thị 2 dòng cho hóa đơn "HD001"
      And mỗi dòng hiển thị thông tin thông báo sai sót khác nhau

    # ------------------------------------------
    # BỘ LỌC ÁP DỤNG
    # ------------------------------------------

    Scenario: Danh sách bộ lọc áp dụng cho Báo cáo hóa đơn thông báo sai sót
      When người dùng mở phần lọc dữ liệu
      Then hệ thống hiển thị các bộ lọc sau:
        | Bộ lọc                         |
        | Thời gian (Kỳ)                 |
        | Hình thức hóa đơn              |
        | Ký hiệu                        |
        | Trạng thái TBSS                |
        | Tính chất hóa đơn              |

    Scenario: Lọc theo trạng thái TBSS
      Given người dùng có 10 thông báo sai sót với các trạng thái khác nhau
      And có 3 thông báo có trạng thái "CQT chấp nhận"
      And có 2 thông báo có trạng thái "Nháp"
      When người dùng lọc theo trạng thái TBSS "CQT chấp nhận"
      Then hệ thống chỉ hiển thị 3 hóa đơn có trạng thái TBSS "CQT chấp nhận"

    # ------------------------------------------
    # XUẤT FILE
    # ------------------------------------------

    Scenario: Xuất Báo cáo hóa đơn thông báo sai sót ra file
      Given người dùng đang xem Báo cáo hóa đơn thông báo sai sót với 8 hóa đơn
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file chứa đầy đủ 8 hóa đơn
      And file bao gồm tất cả thông tin hiển thị trên báo cáo

    Scenario: Xuất báo cáo sau khi lọc
      Given người dùng đang xem Báo cáo hóa đơn thông báo sai sót
      And đã lọc theo trạng thái TBSS "CQT chấp nhận" còn 3 hóa đơn
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file chứa 3 hóa đơn đã lọc
      And file không chứa hóa đơn có trạng thái TBSS khác

    Scenario Outline: Quy tắc đặt tên file khi xuất Báo cáo hóa đơn thông báo sai sót
      Given người dùng đang xem Báo cáo hóa đơn thông báo sai sót với kỳ "<kỳ>"
      And kỳ có ngày bắt đầu "<từ_ngày>" và ngày kết thúc "<đến_ngày>"
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file với tên "<tên_file>"

      Examples:
        | kỳ              | từ_ngày    | đến_ngày   | tên_file                                     |
        | Kỳ này          | 01/01/2026 | 31/03/2026 | BaoCaoHoaDonThongBaoSaiSot_01012026-31032026 |
        | Quý 4/2025      | 01/10/2025 | 31/12/2025 | BaoCaoHoaDonThongBaoSaiSot_01102025-31122025 |
        | Tháng 12/2025   | 01/12/2025 | 31/12/2025 | BaoCaoHoaDonThongBaoSaiSot_01122025-31122025 |
        | Tùy chỉnh       | 15/12/2025 | 20/12/2025 | BaoCaoHoaDonThongBaoSaiSot_15122025-20122025 |

    # ------------------------------------------
    # TRƯỜNG HỢP ĐẶC BIỆT
    # ------------------------------------------

    Scenario: Hiển thị thông báo khi không có hóa đơn thông báo sai sót trong kỳ
      Given người dùng chưa gửi thông báo sai sót nào trong tháng 1/2026
      When người dùng truy cập Báo cáo hóa đơn thông báo sai sót với kỳ "Tháng 1/2026"
      Then hệ thống hiển thị thông báo không có dữ liệu

    Scenario: Hiển thị hóa đơn có nhiều thông báo theo thứ tự thời gian
      Given hóa đơn "HD001" có 3 thông báo sai sót
      And thông báo ngày 15/12/2025, 20/12/2025, 25/12/2025
      When người dùng xem Báo cáo hóa đơn thông báo sai sót
      Then hệ thống hiển thị 3 dòng cho hóa đơn "HD001"
      And các dòng được sắp xếp theo ngày thông báo từ mới nhất đến cũ nhất



