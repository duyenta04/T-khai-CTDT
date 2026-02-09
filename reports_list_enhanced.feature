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

# ============================================
# BỔ SUNG: LỌC THEO THỜI GIAN - NGÀY XUẤT HÓA ĐƠN
# ============================================

Rule: Các báo cáo lọc theo thời gian dựa trên ngày xuất hóa đơn, không phải ngày tạo

  Background:
    Given người dùng đang xem một báo cáo hóa đơn
    And hệ thống ghi nhận hai loại thời điểm:
      | Loại thời điểm        | Mô tả                                      |
      | Ngày tạo hóa đơn      | Ngày người dùng tạo hóa đơn ở trạng thái nháp |
      | Ngày xuất hóa đơn     | Ngày hóa đơn được phát hành chính thức    |

  # ------------------------------------------
  # NGUYÊN TẮC CƠ BẢN
  # ------------------------------------------

  Scenario: Ngày hóa đơn trong bộ lọc là ngày xuất hóa đơn
    Given người dùng tạo hóa đơn "HD001" ngày 10/12/2025
    But hóa đơn "HD001" được lưu ở trạng thái nháp
    When người dùng xuất hóa đơn "HD001" ngày 15/12/2025
    Then ngày hóa đơn của "HD001" được ghi nhận là 15/12/2025
    And bộ lọc thời gian sẽ sử dụng ngày 15/12/2025 để lọc

  Scenario: Hóa đơn nháp không xuất hiện trong báo cáo
    Given người dùng tạo 5 hóa đơn nháp trong tháng 12/2025
    But chưa xuất hóa đơn nào
    When người dùng lọc báo cáo theo kỳ "Tháng 12/2025"
    Then hệ thống hiển thị 0 hóa đơn
    And hiển thị thông báo không có dữ liệu

  Scenario: Hóa đơn được tính vào kỳ theo ngày xuất, không theo ngày tạo
    Given người dùng tạo hóa đơn "HD001" ngày 28/11/2025
    When người dùng xuất hóa đơn "HD001" ngày 05/12/2025
    And người dùng lọc báo cáo theo kỳ "Tháng 12/2025"
    Then hệ thống hiển thị hóa đơn "HD001"
    When người dùng lọc báo cáo theo kỳ "Tháng 11/2025"
    Then hệ thống không hiển thị hóa đơn "HD001"

  # ------------------------------------------
  # LỌC THEO KHOẢNG THỜI GIAN
  # ------------------------------------------

  Scenario: Lọc theo khoảng thời gian chỉ bao gồm hóa đơn đã xuất
    Given người dùng có các hóa đơn sau:
      | Mã hóa đơn | Ngày tạo   | Ngày xuất  | Trạng thái |
      | HD001      | 01/12/2025 | 05/12/2025 | Đã xuất    |
      | HD002      | 02/12/2025 | 10/12/2025 | Đã xuất    |
      | HD003      | 03/12/2025 | -          | Nháp       |
      | HD004      | 04/12/2025 | 15/12/2025 | Đã xuất    |
    When người dùng lọc theo khoảng thời gian từ "05/12/2025" đến "12/12/2025"
    Then hệ thống hiển thị 2 hóa đơn:
      | Mã hóa đơn | Ngày hiển thị |
      | HD001      | 05/12/2025    |
      | HD002      | 10/12/2025    |
    And hóa đơn "HD003" không hiển thị vì chưa được xuất
    And hóa đơn "HD004" không hiển thị vì xuất ngoài khoảng thời gian

  Scenario: Lọc theo quý dựa trên ngày xuất hóa đơn
    Given người dùng có các hóa đơn sau:
      | Mã hóa đơn | Ngày tạo   | Ngày xuất  |
      | HD001      | 15/09/2025 | 05/10/2025 |
      | HD002      | 20/09/2025 | 15/11/2025 |
      | HD003      | 25/09/2025 | 20/12/2025 |
    When người dùng lọc theo kỳ "Quý 4/2025" (01/10/2025 đến 31/12/2025)
    Then hệ thống hiển thị đầy đủ 3 hóa đơn
    When người dùng lọc theo kỳ "Quý 3/2025" (01/07/2025 đến 30/09/2025)
    Then hệ thống hiển thị 0 hóa đơn

  Scenario: Lọc theo tháng dựa trên ngày xuất hóa đơn
    Given người dùng tạo hóa đơn "HD001" ngày 30/11/2025
    And người dùng tạo hóa đơn "HD002" ngày 30/11/2025
    When người dùng xuất hóa đơn "HD001" ngày 01/12/2025
    And người dùng xuất hóa đơn "HD002" ngày 05/12/2025
    And người dùng lọc theo kỳ "Tháng 12/2025"
    Then hệ thống hiển thị 2 hóa đơn với ngày xuất trong tháng 12

  # ------------------------------------------
  # TRƯỜNG HỢP CHUYỂN ĐỔI TRẠNG THÁI
  # ------------------------------------------

  Scenario: Hóa đơn chuyển từ nháp sang đã xuất được tính vào kỳ xuất
    Given người dùng tạo hóa đơn nháp "HD001" ngày 15/11/2025
    And báo cáo tháng 11/2025 không có hóa đơn "HD001"
    When người dùng xuất hóa đơn "HD001" ngày 10/12/2025
    And người dùng lọc báo cáo theo kỳ "Tháng 12/2025"
    Then hệ thống hiển thị hóa đơn "HD001" với ngày hóa đơn là 10/12/2025
    When người dùng lọc báo cáo theo kỳ "Tháng 11/2025"
    Then hệ thống không hiển thị hóa đơn "HD001"

  Scenario: Nhiều hóa đơn nháp được xuất trong cùng một kỳ
    Given người dùng có 10 hóa đơn nháp được tạo trong tháng 11/2025
    When người dùng xuất tất cả 10 hóa đơn trong khoảng 01/12/2025 đến 15/12/2025
    And người dùng lọc báo cáo theo kỳ "Tháng 12/2025"
    Then hệ thống hiển thị đầy đủ 10 hóa đơn
    And tất cả hóa đơn có ngày hóa đơn trong khoảng 01/12 đến 15/12

  # ------------------------------------------
  # KẾT HỢP VỚI BỘ LỌC KHÁC
  # ------------------------------------------

  Scenario: Kết hợp lọc thời gian và ký hiệu dựa trên ngày xuất
    Given người dùng có các hóa đơn sau:
      | Mã hóa đơn | Ký hiệu | Ngày tạo   | Ngày xuất  |
      | HD001      | 1C25TSA | 01/11/2025 | 05/12/2025 |
      | HD002      | 1C25TSA | 02/11/2025 | 10/12/2025 |
      | HD003      | 2C25TSA | 03/11/2025 | 15/12/2025 |
      | HD004      | 1C25TSA | 04/11/2025 | -          |
    When người dùng lọc theo kỳ "Tháng 12/2025"
    And người dùng lọc thêm theo ký hiệu "1C25TSA"
    Then hệ thống hiển thị 2 hóa đơn:
      | Mã hóa đơn | Ngày xuất  |
      | HD001      | 05/12/2025 |
      | HD002      | 10/12/2025 |
    And hóa đơn "HD003" không hiển thị vì khác ký hiệu
    And hóa đơn "HD004" không hiển thị vì chưa xuất

  Scenario: Kết hợp lọc thời gian và trạng thái CQT
    Given người dùng xuất 5 hóa đơn trong tháng 12/2025
    And 3 hóa đơn có trạng thái "CQT đã tiếp nhận"
    And 2 hóa đơn có trạng thái "Chưa gửi CQT"
    When người dùng lọc theo kỳ "Tháng 12/2025"
    And người dùng lọc thêm theo trạng thái "CQT đã tiếp nhận"
    Then hệ thống chỉ hiển thị 3 hóa đơn đã xuất và có trạng thái "CQT đã tiếp nhận"

  # ------------------------------------------
  # NGÀY XUẤT TRÙNG BIÊN KHOẢNG THỜI GIAN
  # ------------------------------------------

  Scenario: Hóa đơn xuất vào ngày đầu kỳ được tính vào kỳ
    Given người dùng xuất hóa đơn "HD001" ngày 01/12/2025
    When người dùng lọc theo kỳ "Tháng 12/2025" (01/12/2025 đến 31/12/2025)
    Then hệ thống hiển thị hóa đơn "HD001"

  Scenario: Hóa đơn xuất vào ngày cuối kỳ được tính vào kỳ
    Given người dùng xuất hóa đơn "HD001" ngày 31/12/2025
    When người dùng lọc theo kỳ "Tháng 12/2025" (01/12/2025 đến 31/12/2025)
    Then hệ thống hiển thị hóa đơn "HD001"

  Scenario: Hóa đơn xuất trước ngày đầu kỳ không được tính vào kỳ
    Given người dùng xuất hóa đơn "HD001" ngày 30/11/2025
    When người dùng lọc theo kỳ "Tháng 12/2025" (01/12/2025 đến 31/12/2025)
    Then hệ thống không hiển thị hóa đơn "HD001"

  Scenario: Hóa đơn xuất sau ngày cuối kỳ không được tính vào kỳ
    Given người dùng xuất hóa đơn "HD001" ngày 01/01/2026
    When người dùng lọc theo kỳ "Tháng 12/2025" (01/12/2025 đến 31/12/2025)
    Then hệ thống không hiển thị hóa đơn "HD001"

  # ------------------------------------------
  # BÁO CÁO THEO NĂM DỰA TRÊN NGÀY XUẤT
  # ------------------------------------------

  Scenario: Lọc theo năm dựa trên ngày xuất hóa đơn
    Given người dùng có các hóa đơn sau:
      | Mã hóa đơn | Ngày tạo   | Ngày xuất  |
      | HD001      | 15/12/2024 | 10/01/2025 |
      | HD002      | 20/12/2024 | 15/06/2025 |
      | HD003      | 25/12/2024 | 20/11/2025 |
      | HD004      | 28/12/2024 | 05/01/2026 |
    When người dùng lọc theo năm "2025"
    Then hệ thống hiển thị 3 hóa đơn:
      | Mã hóa đơn | Ngày xuất  |
      | HD001      | 10/01/2025 |
      | HD002      | 15/06/2025 |
      | HD003      | 20/11/2025 |
    And hóa đơn "HD004" không hiển thị vì xuất trong năm 2026

  # ------------------------------------------
  # XUẤT BÁO CÁO VỚI LỌC THỜI GIAN
  # ------------------------------------------

  Scenario: Xuất báo cáo theo kỳ chỉ bao gồm hóa đơn đã xuất trong kỳ
    Given người dùng có 15 hóa đơn nháp được tạo trong tháng 11/2025
    And có 10 hóa đơn đã được xuất trong tháng 12/2025
    When người dùng lọc báo cáo theo kỳ "Tháng 12/2025"
    And người dùng xuất báo cáo ra file
    Then file chứa đúng 10 hóa đơn đã xuất trong tháng 12
    And file không chứa 15 hóa đơn nháp được tạo trong tháng 11

  Scenario: Tên file xuất báo cáo dựa trên khoảng thời gian lọc
    Given người dùng lọc Bảng kê tổng hợp theo kỳ "Tháng 12/2025"
    And kỳ có khoảng thời gian từ "01/12/2025" đến "31/12/2025"
    When người dùng xuất toàn bộ báo cáo ra file
    Then hệ thống tạo file với tên "BangKeTongHop_01122025-31122025"
    And file chỉ chứa hóa đơn có ngày xuất từ 01/12 đến 31/12

  # ------------------------------------------
  # GHI CHÚ VÀ LƯU Ý
  # ------------------------------------------

  Scenario: Hiển thị tooltip giải thích về ngày hóa đơn
    Given người dùng đang ở màn hình báo cáo
    When người dùng di chuột qua cột "Ngày hóa đơn"
    Then hệ thống hiển thị tooltip:
      """
      Ngày hóa đơn: Ngày hóa đơn được phát hành chính thức
      Lưu ý: Hóa đơn ở trạng thái nháp chưa được phát hành sẽ không được tính
      """

  Scenario: Hiển thị tooltip giải thích về bộ lọc thời gian
    Given người dùng đang ở màn hình báo cáo
    When người dùng mở bộ lọc thời gian
    Then hệ thống hiển thị ghi chú:
      """
      Báo cáo chỉ hiển thị hóa đơn đã được phát hành (xuất) trong kỳ
      Hóa đơn ở trạng thái nháp sẽ không xuất hiện trong báo cáo
      """
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
        | Thông tin giá trị           | Số tháng báo               |
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



