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
        | loại_báo_cáo                    | quyền                                |
        | Bảng kê tổng hợp                | Báo cáo - Bảng kê tổng hợp           |
        | Bảng kê hóa đơn theo sản phẩm   | Báo cáo - Bảng kê theo sản phẩm      |

    Scenario: Người dùng không có quyền truy cập báo cáo
      Given người dùng "Jane" không có quyền "Báo cáo - Bảng kê tổng hợp"
      When người dùng "Jane" truy cập "Bảng kê tổng hợp"
      Then hệ thống hiển thị thông báo không có quyền truy cập

  # ============================================
  # RULE: BỘ LỌC CHUNG CHO CÁC BÁO CÁO
  # ============================================

  Rule: Các báo cáo có bộ lọc chung với logic xử lý giống nhau

    Background:
      Given người dùng đang xem một báo cáo hóa đơn

    # ------------------------------------------
    # LỌC THEO THỜI GIAN
    # ------------------------------------------

    Scenario Outline: Lọc hóa đơn theo khoảng thời gian
      Given người dùng đã phát hành các hóa đơn trong năm 2025
      When người dùng lọc theo kỳ "<kỳ>" từ "<từ_ngày>" đến "<đến_ngày>"
      Then hệ thống chỉ hiển thị các hóa đơn có ngày hóa đơn từ "<từ_ngày>" đến "<đến_ngày>"

      Examples:
        | kỳ              | từ_ngày    | đến_ngày   |
        | Quý 4/2025      | 01/10/2025 | 31/12/2025 |
        | Tháng 12/2025   | 01/12/2025 | 31/12/2025 |
        | Tùy chỉnh       | 15/12/2025 | 20/12/2025 |

    # ------------------------------------------
    # LỌC THEO KY HIỆU HÓA ĐƠN
    # ------------------------------------------

    Scenario: Lọc hóa đơn theo ký hiệu hóa đơn
      Given người dùng có 3 ký hiệu hóa đơn: "1C25TSA", "2C25TSA", "3C25TSA"
      And ký hiệu "1C25TSA" có 10 hóa đơn
      And ký hiệu "2C25TSA" có 5 hóa đơn
      When người dùng lọc theo ký hiệu "1C25TSA"
      Then hệ thống chỉ hiển thị 10 hóa đơn có ký hiệu "1C25TSA"

    # ------------------------------------------
    # LỌC THEO SỐ HÓA ĐƠN
    # ------------------------------------------

    Scenario: Lọc hóa đơn theo số hóa đơn
      Given người dùng đã phát hành hóa đơn số "HD000001"
      When người dùng lọc theo số hóa đơn "HD000001"
      Then hệ thống chỉ hiển thị hóa đơn có số "HD000001"

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
    # LỌC THEO TRẠNG THÁI CQT
    # ------------------------------------------

    Scenario Outline: Lọc hóa đơn theo trạng thái CQT - Hóa đơn máy tính tiền
      Given người dùng chỉ sử dụng hóa đơn máy tính tiền
      When người dùng lọc theo trạng thái CQT "<trạng_thái>"
      Then hệ thống chỉ hiển thị các hóa đơn máy tính tiền có trạng thái "<trạng_thái>"

      Examples:
        | trạng_thái                     |
        | Chưa gửi CQT                   |
        | Lỗi gửi hóa đơn cho CQT        |
        | CQT chưa tiếp nhận             |
        | CQT đã tiếp nhận               |
        | CQT kiểm tra không hợp lệ      |

    Scenario Outline: Lọc hóa đơn theo trạng thái CQT - Hóa đơn thường có mã
      Given người dùng chỉ sử dụng hóa đơn thường có mã CQT
      When người dùng lọc theo trạng thái CQT "<trạng_thái>"
      Then hệ thống chỉ hiển thị các hóa đơn thường có mã với trạng thái "<trạng_thái>"

      Examples:
        | trạng_thái                     |
        | Phát hành lỗi                  |
        | CQT chưa cấp mã                |
        | CQT đã cấp mã                  |
        | Không đủ điều kiện cấp mã      |

    Scenario Outline: Lọc hóa đơn theo trạng thái CQT - Hóa đơn thường không mã
      Given người dùng chỉ sử dụng hóa đơn thường không mã CQT
      When người dùng lọc theo trạng thái CQT "<trạng_thái>"
      Then hệ thống chỉ hiển thị các hóa đơn thường không mã với trạng thái "<trạng_thái>"

      Examples:
        | trạng_thái                     |
        | Phát hành lỗi                  |
        | Đã phát hành                   |
        | CQT đã tiếp nhận               |
        | CQT kiểm tra không hợp lệ      |

    Scenario Outline: Hiển thị trạng thái CQT theo loại hóa đơn người dùng sử dụng
      Given người dùng sử dụng "<loại_hóa_đơn_sử_dụng>"
      When người dùng mở bộ lọc trạng thái CQT
      Then hệ thống hiển thị các trạng thái "<các_trạng_thái_hiển_thị>"

      Examples:
        | loại_hóa_đơn_sử_dụng                                    | các_trạng_thái_hiển_thị                                      |
        | Hóa đơn máy tính tiền                                   | Hóa đơn máy tính tiền                                        |
        | Hóa đơn thường có mã                                    | Hóa đơn thường có mã                                         |
        | Hóa đơn thường không mã                                 | Hóa đơn thường không mã                                      |
        | Hóa đơn máy tính tiền, Hóa đơn thường có mã             | Hóa đơn máy tính tiền, Hóa đơn thường có mã                  |
        | Hóa đơn máy tính tiền, Hóa đơn thường không mã          | Hóa đơn máy tính tiền, Hóa đơn thường không mã               |
        | Hóa đơn thường có mã, Hóa đơn thường không mã           | Hóa đơn thường có mã, Hóa đơn thường không mã                |
        | Hóa đơn máy tính tiền, Hóa đơn thường có mã, không mã   | Hóa đơn máy tính tiền, Hóa đơn thường có mã, không mã        |

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
        | Nháp                           |

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

    # ------------------------------------------
    # XUẤT FILE
    # ------------------------------------------

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

  # ============================================
  # RULE: BẢNG KÊ CHI TIẾT
  # ============================================

  Rule: Bảng kê chi tiết hiển thị thông tin chi tiết đến từng dòng sản phẩm của hóa đơn

    Background:
      Given người dùng có quyền "Báo cáo - Bảng kê chi tiết"
      And người dùng đang truy cập Bảng kê chi tiết

    # ------------------------------------------
    # CÁC TRƯỜNG THÔNG TIN
    # ------------------------------------------

    Scenario: Danh sách các trường thông tin hiển thị trên Bảng kê chi tiết
      Then hệ thống hiển thị các cột sau:
        | Nhóm thông tin              | Tên cột                    |
        | Thông tin định danh         | STT                        |
        | Thông tin định danh         | Ký hiệu                    |
        | Thông tin định danh         | Số hóa đơn                 |
        | Thông tin định danh         | Ngày hóa đơn               |
        | Thông tin định danh         | Ngày ký hóa đơn            |
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
        | Thông tin sản phẩm          | ĐVT                        |
        | Thông tin sản phẩm          | Số lượng                   |
        | Thông tin sản phẩm          | Đơn giá                    |
        | Thông tin sản phẩm          | Thành tiền                 |
        | Thông tin sản phẩm          | Tỷ lệ CK                   |
        | Thông tin sản phẩm          | Tiền chiết khấu            |
        | Thông tin sản phẩm          | Thuế suất                  |
        | Thông tin sản phẩm          | Tiền thuế GTGT             |
        | Thông tin giá trị           | Tổng tiền                  |
        | Thông tin bổ sung           | Ghi chú                    |
        | Thông tin bổ sung           | Người lập                  |

    # ------------------------------------------
    # XEM DANH SÁCH
    # ------------------------------------------

    Scenario: Xem chi tiết từng dòng sản phẩm của hóa đơn
      Given hóa đơn "HD001" có 3 dòng sản phẩm
      And hóa đơn "HD002" có 2 dòng sản phẩm
      When người dùng truy cập Bảng kê chi tiết với kỳ "Tháng 12/2025"
      Then hệ thống hiển thị 5 dòng dữ liệu tương ứng với từng sản phẩm
      And mỗi dòng hiển thị đầy đủ thông tin hóa đơn và thông tin sản phẩm

    Scenario: Hiển thị thông tin chi tiết của mỗi dòng sản phẩm
      Given hóa đơn "HD001" có dòng sản phẩm với thông tin sau:
        | Thuộc tính                   | Giá trị                        |
        | Ký hiệu                      | 1C25TSA                        |
        | Số hóa đơn                   | HD000001                       |
        | Ngày hóa đơn                 | 19/12/2025                     |
        | Ngày ký hóa đơn              | 19/12/2025                     |
        | Tính chất hóa đơn            | Hóa đơn gốc                    |
        | Trạng thái gửi CQT           | CQT đã tiếp nhận               |
        | Mã khách hàng                | KH001                          |
        | Mã số thuế                   | 001196088999                   |
        | Tên khách hàng               | Công ty TNHH ABC               |
        | Địa chỉ                      | 1A Yết Kiếu                    |
        | Họ tên người mua             | Nguyễn Văn A                   |
        | Hình thức thanh toán         | Tiền mặt                       |
        | Loại tiền                    | VND                            |
        | Tỷ giá                       | 1                              |
        | Mã hàng                      | SP001                          |
        | Tên hàng                     | Bàn ghế văn phòng              |
        | ĐVT                          | Bộ                             |
        | Số lượng                     | 5                              |
        | Đơn giá                      | 2,000,000                      |
        | Thành tiền                   | 10,000,000                     |
        | Tỷ lệ CK                     | 0%                             |
        | Tiền chiết khấu              | 0                              |
        | Thuế suất                    | 10%                            |
        | Tiền thuế GTGT               | 1,000,000                      |
        | Tổng tiền                    | 11,000,000                     |
        | Ghi chú                      |                                |
        | Người lập                    | John                           |
      When người dùng xem Bảng kê chi tiết
      Then hệ thống hiển thị đầy đủ thông tin của dòng sản phẩm này

    Scenario: Hóa đơn có nhiều dòng sản phẩm được hiển thị thành nhiều dòng riêng biệt
      Given hóa đơn "HD003" có 3 dòng sản phẩm:
        | Mã hàng | Tên hàng          | Số lượng | Đơn giá   | Thành tiền |
        | SP001   | Bàn văn phòng     | 2        | 1,000,000 | 2,000,000  |
        | SP002   | Ghế văn phòng     | 4        | 500,000   | 2,000,000  |
        | SP003   | Tủ tài liệu       | 1        | 3,000,000 | 3,000,000  |
      When người dùng xem Bảng kê chi tiết
      Then hệ thống hiển thị 3 dòng riêng biệt cho hóa đơn "HD003"
      And mỗi dòng có cùng thông tin hóa đơn nhưng khác thông tin sản phẩm

    # ------------------------------------------
    # BỘ LỌC ÁP DỤNG CHO BẢNG KÊ CHI TIẾT
    # ------------------------------------------

    Scenario: Danh sách bộ lọc áp dụng cho Bảng kê chi tiết
      When người dùng mở phần lọc dữ liệu
      Then hệ thống hiển thị các bộ lọc sau:
        | Bộ lọc                         |
        | Thời gian (Kỳ)                 |
        | Hình thức hóa đơn              |
        | Ký hiệu                        |
        | Trạng thái gửi CQT             |
        | Tính chất hóa đơn              |
        | Người lập hóa đơn              |

    # ------------------------------------------
    # XUẤT FILE
    # ------------------------------------------

    Scenario: Xuất Bảng kê chi tiết ra file
      Given người dùng đang xem Bảng kê chi tiết với 20 dòng sản phẩm
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file chứa đầy đủ 20 dòng sản phẩm
      And file bao gồm tất cả thông tin hiển thị trên báo cáo

    Scenario: Xuất báo cáo sau khi lọc
      Given người dùng đang xem Bảng kê chi tiết
      And đã lọc theo ký hiệu "1C25TSA" còn 8 dòng sản phẩm
      When người dùng xuất báo cáo ra file
      Then hệ thống tạo file chứa 8 dòng sản phẩm đã lọc
      And file không chứa dòng sản phẩm của ký hiệu khác

    # ------------------------------------------
    # TRƯỜNG HỢP ĐẶC BIỆT
    # ------------------------------------------

    Scenario: Hiển thị thông báo khi không có hóa đơn trong kỳ
      Given người dùng chưa phát hành hóa đơn nào trong tháng 1/2026
      When người dùng truy cập Bảng kê chi tiết với kỳ "Tháng 1/2026"
      Then hệ thống hiển thị thông báo không có dữ liệu

    Scenario: Hiển thị dòng sản phẩm có ngoại tệ với tỷ giá
      Given hóa đơn "HD004" có dòng sản phẩm sử dụng ngoại tệ "USD"
      And có tỷ giá "23,500 VND/USD"
      And đơn giá sản phẩm là "100 USD"
      When người dùng xem Bảng kê chi tiết
      Then hệ thống hiển thị loại tiền "USD"
      And hiển thị tỷ giá "23,500"
      And hiển thị đơn giá "100" với đơn vị "USD"

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

    Scenario: Xuất file tab chính
      Given người dùng đang xem tab chính với 5 hóa đơn
      When người dùng xuất tab chính ra file
      Then hệ thống tạo file chứa đầy đủ 5 hóa đơn
      And file bao gồm tất cả thông tin hiển thị trên tab

    Scenario: Xuất file tab bị tác động
      Given người dùng đang xem tab bị tác động với 5 hóa đơn
      When người dùng xuất tab bị tác động ra file
      Then hệ thống tạo file chứa đầy đủ 5 hóa đơn bị tác động
      And file bao gồm tất cả thông tin hiển thị trên tab

    Scenario: Xuất file cả 2 tab
      Given tab chính có 5 hóa đơn
      And tab bị tác động có 5 hóa đơn tương ứng
      When người dùng xuất toàn bộ báo cáo ra file
      Then hệ thống tạo file chứa 2 sheet tương ứng với 2 tab
      And sheet 1 chứa danh sách hóa đơn của tab chính
      And sheet 2 chứa danh sách hóa đơn của tab bị tác động

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
        | Thông tin định danh         | STT                        |
        | Thông tin định danh         | Ký hiệu                    |
        | Thông tin định danh         | Số hóa đơn                 |
        | Thông tin định danh         | Ngày hóa đơn               |
        | Trạng thái và tính chất     | Tính chất hóa đơn          |
        | Thông tin khách hàng        | Mã khách hàng              |
        | Thông tin khách hàng        | Mã số thuế                 |
        | Thông tin khách hàng        | Tên khách hàng             |
        | Thông tin khách hàng        | Địa chỉ                    |
        | Thông tin giá trị           | Tổng tiền                  |
        | Thông tin thông báo         | Số thông báo               |
        | Thông tin thông báo         | Ngày thông báo             |
        | Thông tin thông báo         | Lý do                      |
        | Thông tin thông báo         | Nội dung báo               |
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
        | Tổng tiền                    | 11,000,000                     |
        | Số thông báo                 | TB000001                       |
        | Ngày thông báo               | 20/12/2025                     |
        | Lý do                        | Sai số tiền                    |
        | Nội dung báo                 | Ghi nhầm tổng tiền             |
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



