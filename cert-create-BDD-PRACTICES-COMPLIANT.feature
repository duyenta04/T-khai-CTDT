# language: vi
@certificate-create
Feature: Lập chứng từ khấu trừ thuế thu nhập cá nhân
  Để ghi nhận việc khấu trừ thuế cho cá nhân và hộ kinh doanh
  Với vai trò kế toán
  Tôi cần lập chứng từ khấu trừ thuế thu nhập cá nhân

  Background:
    Given kế toán đã đăng nhập vào hệ thống
    And kế toán có quyền quản lý chứng từ
    And hệ thống có các mẫu chứng từ đã đăng ký

  Rule: Mẫu chứng từ cố định theo năm hiện tại
    
    @fixed-template @auto-template
    Scenario: Mẫu chứng từ tự động theo năm hiện tại
      Given năm hiện tại là 2026
      When kế toán bắt đầu lập chứng từ mới
      Then mẫu chứng từ tự động là "03/TNCN-CT/26E"
      And ký hiệu mẫu là "03/TNCN"
      And ký hiệu chứng từ là "CT/26E"
    
    @fixed-template @auto-template
    Scenario Outline: Mẫu chứng từ thay đổi theo năm
      Given năm hiện tại là <year>
      When kế toán lập chứng từ mới
      Then mẫu chứng từ tự động là "03/TNCN-CT/<yy>E"
      
      Examples:
        | year | yy |
        | 2026 | 26 |
        | 2027 | 27 |
        | 2028 | 28 |
    
    @fixed-template @template-structure
    Scenario: Cấu trúc ký hiệu chứng từ
      Given mẫu chứng từ "03/TNCN-CT/26E"
      Then ký hiệu chứng từ "CT/26E" có cấu trúc:
        | Vị trí   | Ký tự | Ý nghĩa                          |
        | 1-2      | CT    | Viết tắt của "Chứng từ"          |
        | 3        | /     | Ký tự phân cách                  |
        | 4-5      | 26    | 2 chữ số cuối năm lập (2026)     |
        | 6        | E     | Hình thức điện tử (Electronic)   |
    
    @fixed-template @display
    Scenario: Hiển thị mẫu trên màn hình lập
      Given kế toán vào màn hình lập chứng từ
      And năm hiện tại là 2026
      Then mẫu chứng từ hiển thị là "03/TNCN-CT/26E"
      And mẫu không thể thay đổi

  Rule: Số chứng từ chỉ sinh khi phát hành
    
    @auto-number @draft
    Scenario: Lưu nháp không sinh số chứng từ
      Given kế toán đang lập chứng từ
      And năm hiện tại là 2026
      And mẫu chứng từ tự động là "03/TNCN-CT/26E"
      When kế toán lưu nháp
      Then chứng từ có trạng thái "Nháp"
      And số chứng từ chưa được sinh ra
    
    @auto-number @publish
    Scenario: Sinh số chứng từ khi phát hành
      Given chứng từ có trạng thái "Nháp"
      And mẫu chứng từ là "03/TNCN-CT/26E"
      And số chứng từ cuối cùng đã phát hành là "0000050"
      When kế toán phát hành chứng từ
      Then số chứng từ "0000051" được sinh tự động
      And chứng từ được gửi lên CQT với số "0000051"
    
    @auto-number @sequence
    Scenario: Cảnh báo khi phát hành chứng từ sai thứ tự
      Given chứng từ A tạo lúc 10:00 có trạng thái "Nháp"
      And chứng từ B tạo lúc 10:30 có trạng thái "Đã phát hành" số "0000101"
      When kế toán phát hành chứng từ A
      Then hệ thống hiển thị cảnh báo "Có chứng từ mới hơn đã được phát hành"
      And hệ thống yêu cầu xác nhận phát hành

  Rule: Chọn ngày chứng từ

    @date-selection
    Scenario: Chọn ngày chứng từ
      Given kế toán đang lập chứng từ
      When kế toán chọn ngày "15/01/2026"
      Then ngày chứng từ là "15/01/2026"

  Rule: Tra cứu thông tin người nộp thuế

    @taxpayer-lookup
    Scenario: Tra cứu thành công từ mã số thuế
      Given kế toán đang nhập thông tin người nộp thuế
      When kế toán tra cứu mã số thuế "8765432100"
      Then hệ thống điền tự động thông tin người nộp thuế

    @taxpayer-lookup
    Scenario: Tra cứu không tìm thấy
      Given kế toán đang nhập thông tin người nộp thuế
      When kế toán tra cứu mã số thuế không tồn tại
      Then hệ thống thông báo không tìm thấy
      And hệ thống cho phép nhập thủ công

  Rule: Thông tin người nộp thuế

    @taxpayer-info @validation
    Scenario: Yêu cầu có mã số thuế hoặc CCCD
      Given kế toán đang lập chứng từ
      And không có mã số thuế
      And không có số CCCD
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Phải nhập Mã số thuế hoặc Số CCCD"

    @taxpayer-info @validation
    Scenario Outline: Kiểm tra định dạng mã số thuế
      Given kế toán đang nhập mã số thuế
      When kế toán nhập mã số thuế "<value>"
      Then hệ thống <result>

      Examples:
        | value         | result                               |
        | 0123456789    | chấp nhận mã số thuế                 |
        | 0123456789012 | chấp nhận mã số thuế                 |
        | 012345        | hiển thị lỗi "MST phải 10 hoặc 13 số"|
        | ABC123        | hiển thị lỗi "MST chỉ chứa số"       |

    @taxpayer-info @validation
    Scenario: Yêu cầu chọn cá nhân cư trú
      Given kế toán đang lập chứng từ
      And chưa chọn cá nhân cư trú
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Phải chọn Cá nhân cư trú"

    @taxpayer-info @validation
    Scenario Outline: Yêu cầu các trường bắt buộc
      Given kế toán đang lập chứng từ
      And trường <field> để trống
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "<error_message>"

      Examples:
        | field         | error_message                        |
        | Họ và tên     | Họ và tên không được để trống        |
        | Địa chỉ       | Địa chỉ không được để trống          |
        | Quốc tịch     | Quốc tịch không được để trống        |
        | Số điện thoại | Số điện thoại không được để trống    |

  Rule: Khoản thu nhập

    @income-type
    Scenario: Chọn loại thu nhập
      Given kế toán đang nhập thông tin thuế
      When kế toán chọn loại thu nhập "Thu nhập từ tiền lương, tiền công"
      Then loại thu nhập là "Thu nhập từ tiền lương, tiền công"

    @income-type
    Scenario: Nhập khoản thu nhập khác
      Given kế toán đang nhập thông tin thuế
      When kế toán chọn "Khác"
      And kế toán nhập khoản thu nhập "Thu nhập từ đầu tư"
      Then khoản thu nhập là "Thu nhập từ đầu tư"

    @income-type @validation
    Scenario: Yêu cầu chọn khoản thu nhập
      Given kế toán đang lập chứng từ
      And chưa chọn khoản thu nhập
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Khoản thu nhập không được để trống"

  Rule: Tính toán thuế tự động

    @tax-calculation
    Scenario: Tính thu nhập tính thuế
      Given thu nhập chịu thuế là 30,000,000 VNĐ
      And bảo hiểm là 3,150,000 VNĐ
      And giảm trừ gia cảnh là 11,000,000 VNĐ
      When hệ thống tính toán thuế
      Then thu nhập tính thuế là 15,850,000 VNĐ

    @tax-calculation
    Scenario: Tính số thuế theo biểu lũy tiến
      Given thu nhập tính thuế là 15,850,000 VNĐ
      When hệ thống tính số thuế
      Then số thuế là 1,627,500 VNĐ

    @tax-calculation
    Scenario: Cập nhật tự động khi thay đổi bảo hiểm
      Given thu nhập chịu thuế là 30,000,000 VNĐ
      And bảo hiểm là 2,000,000 VNĐ
      And thu nhập tính thuế là 17,000,000 VNĐ
      When kế toán thay đổi bảo hiểm thành 3,150,000 VNĐ
      Then thu nhập tính thuế tự động cập nhật thành 15,850,000 VNĐ
      And số thuế tự động cập nhật thành 1,627,500 VNĐ

    @tax-calculation
    Scenario: Cập nhật tự động khi nhập quỹ hưu trí
      Given thu nhập chịu thuế là 30,000,000 VNĐ
      And bảo hiểm là 3,150,000 VNĐ
      And thu nhập tính thuế là 15,850,000 VNĐ
      When kế toán nhập quỹ hưu trí tự nguyện 1,000,000 VNĐ
      Then thu nhập tính thuế tự động cập nhật thành 14,850,000 VNĐ
      And số thuế tự động cập nhật

    @tax-calculation @edge-case
    Scenario: Thu nhập tính thuế không âm
      Given thu nhập chịu thuế là 2,000,000 VNĐ
      And các khoản giảm trừ lớn hơn thu nhập
      When hệ thống tính toán thuế
      Then thu nhập tính thuế là 0 VNĐ
      And số thuế là 0 VNĐ

    @tax-calculation
    Scenario: Làm tròn số thuế
      Given thu nhập tính thuế có số lẻ
      When hệ thống tính số thuế
      Then số thuế được làm tròn đến đơn vị VNĐ

  Rule: Tính thuế cho nhiều tháng

    @multi-month
    Scenario: Tính thuế cho cả năm
      Given kế toán chọn từ tháng 1 đến tháng 12
      And năm là 2025
      And thu nhập chịu thuế mỗi tháng là 30,000,000 VNĐ
      When hệ thống tính toán thuế
      Then số thuế mỗi tháng là 1,627,500 VNĐ
      And tổng số thuế cả năm là 19,530,000 VNĐ

    @multi-month
    Scenario: Tính thuế cho một tháng
      Given kế toán chọn từ tháng 6 đến tháng 6
      And thu nhập chịu thuế là 30,000,000 VNĐ
      When hệ thống tính toán thuế
      Then số thuế là 1,627,500 VNĐ

  Rule: Validation thời gian

    @validation @time
    Scenario: Đến tháng phải lớn hơn hoặc bằng từ tháng
      Given kế toán nhập từ tháng 6
      When kế toán nhập đến tháng 3
      And kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Đến tháng phải lớn hơn hoặc bằng Từ tháng"

    @validation @time
    Scenario: Năm không được lớn hơn năm hiện tại
      Given năm hiện tại là 2025
      When kế toán nhập năm 2026
      And kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Năm không được lớn hơn năm hiện tại"

  Rule: Validation số tiền

    @validation @amount
    Scenario Outline: Số tiền phải không âm
      Given kế toán đang nhập thông tin thuế
      When kế toán nhập <field> là <value>
      And kế toán lưu chứng từ
      Then hệ thống <result>

      Examples:
        | field                   | value    | result                             |
        | Bảo hiểm                | -100000  | hiển thị lỗi "Số tiền phải >= 0"   |
        | Khoản từ thiện          | -50000   | hiển thị lỗi "Số tiền phải >= 0"   |
        | Tổng thu nhập chịu thuế | -1000000 | hiển thị lỗi "Số tiền phải >= 0"   |
        | Bảo hiểm                | 0        | chấp nhận số tiền                  |
        | Khoản từ thiện          | 100000   | chấp nhận số tiền                  |

  Rule: Thông tin tổ chức tự động

    @organization-info
    Scenario: Điền tự động thông tin tổ chức
      Given kế toán bắt đầu lập chứng từ
      Then thông tin tổ chức được điền tự động:
        | Tên đơn vị    |
        | Mã số thuế    |
        | Địa chỉ       |
        | Số điện thoại |

    @organization-info
    Scenario: Không cho phép sửa thông tin tổ chức
      Given kế toán đang lập chứng từ
      When kế toán thử sửa thông tin tổ chức
      Then thông tin tổ chức không thể chỉnh sửa

  Rule: Xem trước chứng từ
    
    @preview
    Scenario: Xem trước chứng từ đầy đủ
      Given kế toán đang lập chứng từ
      And đã nhập đầy đủ thông tin
      When kế toán xem trước chứng từ
      Then chứng từ được hiển thị dạng xem trước
      And tất cả thông tin đã nhập được hiển thị
      And thông tin không thể chỉnh sửa
    
    @preview
    Scenario: Xem trước với thông tin chưa đầy đủ
      Given kế toán đang lập chứng từ
      And một số thông tin còn thiếu
      When kế toán xem trước chứng từ
      Then chứng từ được hiển thị dạng xem trước
      And các trường thiếu hiển thị trống
    
    @preview
    Scenario: Quay lại chỉnh sửa từ xem trước
      Given kế toán đang xem trước chứng từ
      When kế toán quay lại chỉnh sửa
      Then màn hình lập chứng từ được hiển thị
      And các thông tin đã nhập được giữ nguyên
    
    @preview @format
    Scenario: Hiển thị format đúng trên xem trước
      Given kế toán xem trước chứng từ mẫu "03/TNCN-CT/26E"
      Then mẫu chứng từ hiển thị là "03/TNCN-CT/26E"
      And số tiền hiển thị có dấu phân cách hàng nghìn
      And ngày tháng hiển thị định dạng dd/mm/yyyy

  Rule: Lưu nháp không cần validate
    
    @draft
    Scenario: Lưu nháp với thông tin chưa đầy đủ
      Given kế toán đang lập chứng từ
      And mẫu chứng từ tự động theo năm hiện tại
      And chỉ nhập một số thông tin cơ bản
      And chưa nhập đầy đủ thông tin bắt buộc
      When kế toán lưu nháp
      Then chứng từ được lưu thành công
      And trạng thái chứng từ là "Nháp"
    
    @draft
    Scenario: Lưu nháp ngay khi bắt đầu
      Given kế toán vào màn hình lập chứng từ
      And mẫu chứng từ tự động là "03/TNCN-CT/26E"
      And chưa nhập bất kỳ thông tin nào
      When kế toán lưu nháp
      Then chứng từ được lưu nháp thành công
      And số chứng từ chưa được sinh ra
    
    @draft
    Scenario: Chỉnh sửa chứng từ nháp
      Given chứng từ có trạng thái "Nháp"
      When kế toán mở chứng từ nháp
      Then tất cả các trường có thể chỉnh sửa
    
    @draft @save
    Scenario: Lưu nháp nhiều lần
      Given kế toán đang lập chứng từ nháp
      When kế toán lưu nháp lần thứ nhất
      Then chứng từ được lưu nháp
      When kế toán sửa thông tin
      And kế toán lưu nháp lần thứ hai
      Then chứng từ nháp được cập nhật
      And trạng thái vẫn là "Nháp"
    
    @draft @delete
    Scenario: Xóa chứng từ nháp
      Given chứng từ có trạng thái "Nháp"
      When kế toán xóa chứng từ
      Then hệ thống yêu cầu xác nhận xóa
      When kế toán xác nhận
      Then chứng từ nháp bị xóa

  Rule: Lưu chứng từ

    @save @xml
    Scenario: Lưu dữ liệu theo định dạng XML
      Given kế toán đã hoàn tất chứng từ
      And thu nhập tính thuế là 15,850,000 VNĐ
      And số thuế là 1,627,500 VNĐ
      When kế toán lưu chứng từ
      Then dữ liệu được lưu theo định dạng XML
      And thu nhập tính thuế được lưu là 15850000
      And số thuế được lưu là 1627500

  Rule: Phát hành chứng từ - Validate và gửi CQT
    
    @publish @validation
    Scenario: Validate đầy đủ khi phát hành
      Given chứng từ có trạng thái "Nháp"
      And chưa nhập đầy đủ thông tin bắt buộc
      When kế toán phát hành chứng từ
      Then hệ thống thực hiện validate đầy đủ
      And danh sách lỗi các trường bắt buộc được hiển thị
      And chứng từ không được phát hành
    
    @publish
    Scenario: Phát hành chứng từ hợp lệ
      Given chứng từ có trạng thái "Nháp"
      And đã nhập đầy đủ thông tin bắt buộc
      When kế toán phát hành chứng từ
      Then validate thành công
      And số chứng từ được sinh tự động
      And thông điệp 211 được gửi lên CQT
      And trạng thái chứng từ chuyển thành "Đã gửi CQT"
    
    @publish @message-211
    Scenario: Gửi thông điệp 211 khi phát hành
      Given chứng từ đã validate đầy đủ
      And mẫu chứng từ "03/TNCN-CT/26E"
      And số chứng từ cuối là "0000100"
      When hệ thống phát hành chứng từ
      Then số chứng từ mới "0000101" được sinh ra
      And thông điệp 211 được tạo với:
        | Mẫu chứng từ  | Số chứng từ | Dữ liệu XML         |
        | 03/TNCN-CT/26E| 0000101     | <dữ liệu chứng từ>  |
      And thông điệp 211 được gửi lên CQT
      And trạng thái chuyển thành "Đã gửi CQT"

  Rule: Nhận thông điệp 213 từ CQT
    
    @message-213 @success
    Scenario: CQT chấp nhận chứng từ
      Given chứng từ có trạng thái "Đã gửi CQT"
      When thông điệp 213 được nhận với kết quả "Hợp lệ"
      Then trạng thái chứng từ chuyển thành "CQT chấp nhận"
      And chứng từ không thể chỉnh sửa
    
    @message-213 @validation-error
    Scenario: CQT kiểm tra không hợp lệ - Phải lập chứng từ mới
      Given chứng từ có trạng thái "Đã gửi CQT"
      When thông điệp 213 được nhận với kết quả "Không hợp lệ"
      And thông điệp 213 chứa lỗi:
        | Mã lỗi | Mô tả lỗi                    |
        | E001   | Mã số thuế không đúng định dạng |
      Then trạng thái chứng từ chuyển thành "CQT kiểm tra không hợp lệ"
      And chi tiết lỗi từ CQT được hiển thị
      And chứng từ không thể chỉnh sửa
      And kế toán phải lập chứng từ mới
    
    @message-213 @technical-error
    Scenario: Lỗi kỹ thuật khi gửi CQT
      Given chứng từ có trạng thái "Đã gửi CQT"
      When thông điệp 213 được nhận với lỗi kỹ thuật
      Then trạng thái chuyển thành "Gửi CQT lỗi"
      And thông báo lỗi kỹ thuật được hiển thị
      And nút "Gửi lại" được hiển thị

  Rule: Trạng thái chứng từ và chuyển đổi
    
    @status @lifecycle
    Scenario: Các trạng thái trong vòng đời chứng từ
      Then hệ thống hỗ trợ các trạng thái:
        | Trạng thái                    | Mô tả                                |
        | Nháp                          | Chưa phát hành, có thể sửa           |
        | Đã gửi CQT                    | Đã gửi 211, chờ CQT phản hồi         |
        | CQT kiểm tra không hợp lệ     | CQT trả 213 không hợp lệ             |
        | CQT chấp nhận                 | CQT trả 213 hợp lệ                   |
        | Gửi CQT lỗi                   | Lỗi kỹ thuật khi gửi                 |
    
    @status @transition
    Scenario Outline: Chuyển đổi trạng thái hợp lệ
      Given chứng từ có trạng thái "<from_status>"
      When <event> xảy ra
      Then trạng thái chứng từ chuyển thành "<to_status>"
      
      Examples:
        | from_status                   | event                           | to_status                      |
        | Nháp                          | phát hành thành công            | Đã gửi CQT                     |
        | Đã gửi CQT                    | nhận 213 hợp lệ                 | CQT chấp nhận                  |
        | Đã gửi CQT                    | nhận 213 không hợp lệ           | CQT kiểm tra không hợp lệ      |
        | Đã gửi CQT                    | nhận 213 lỗi kỹ thuật           | Gửi CQT lỗi                    |
        | Gửi CQT lỗi                   | gửi lại thành công              | Đã gửi CQT                     |

  Rule: Actions theo trạng thái
    
    @actions @draft-status
    Scenario: Actions được phép ở trạng thái Nháp
      Given chứng từ có trạng thái "Nháp"
      Then kế toán có thể thực hiện:
        | Action                              |
        | Phát hành                           |
        | Gửi chứng từ (cho KH)               |
        | Tải chứng từ (2 lần chọn)           |
        | Sao chép                            |
        | Lập chứng từ điều chỉnh/Thay thế/Lập TBSS |
        | Xem                                 |
        | Sửa                                 |
        | Xóa                                 |
      And kế toán không thể thực hiện "Gửi CQT lỗi"
      And kế toán không thể thực hiện "Đã gửi CQT"
    
    @actions @sent-status  
    Scenario: Actions được phép ở trạng thái Gửi CQT lỗi
      Given chứng từ có trạng thái "Gửi CQT lỗi"
      Then kế toán có thể thực hiện:
        | Action                              |
        | Tải chứng từ (2 lần chọn)           |
        | Sao chép                            |
        | Xem                                 |
        | Sửa                                 |
        | Xóa                                 |
      And kế toán không thể thực hiện "Phát hành"
      And kế toán không thể thực hiện "Gửi chứng từ (cho KH)"
    
    @actions @processing-status
    Scenario: Actions được phép ở trạng thái Đã gửi CQT
      Given chứng từ có trạng thái "Đã gửi CQT"
      Then kế toán có thể thực hiện:
        | Action                              |
        | Tải chứng từ (2 lần chọn)           |
        | Sao chép                            |
        | Xem                                 |
        | Sửa                                 |
        | Xóa                                 |
      And kế toán không thể thực hiện "Phát hành"
      And kế toán không thể thực hiện "Gửi chứng từ (cho KH)"
    
    @actions @invalid-status
    Scenario: Actions được phép ở trạng thái CQT kiểm tra không hợp lệ
      Given chứng từ có trạng thái "CQT kiểm tra không hợp lệ"
      Then kế toán có thể thực hiện:
        | Action                              |
        | Tải chứng từ (2 lần chọn)           |
        | Sao chép                            |
        | Xem                                 |
      And kế toán không thể thực hiện "Phát hành"
      And kế toán không thể thực hiện "Gửi chứng từ (cho KH)"
      And kế toán không thể thực hiện "Sửa"
      And kế toán không thể thực hiện "Xóa"
      And kế toán có thể lập chứng từ mới
    
    @actions @accepted-status
    Scenario: Actions được phép ở trạng thái CQT chấp nhận
      Given chứng từ có trạng thái "CQT chấp nhận"
      Then kế toán có thể thực hiện:
        | Action                              |
        | Tải chứng từ (2 lần chọn)           |
        | Sao chép                            |
        | Lập chứng từ điều chỉnh/Thay thế/Lập TBSS |
        | Xem                                 |
      And kế toán không thể thực hiện "Phát hành"
      And kế toán không thể thực hiện "Gửi chứng từ (cho KH)"
      And kế toán không thể thực hiện "Sửa"
      And kế toán không thể thực hiện "Xóa"

  Rule: Gửi lại chứng từ khi lỗi kỹ thuật
    
    @retry @technical-error
    Scenario: Gửi lại sau lỗi kỹ thuật
      Given chứng từ có trạng thái "Gửi CQT lỗi"
      When kế toán gửi lại chứng từ
      Then thông điệp 211 được gửi lại
      And số chứng từ được giữ nguyên
      And trạng thái chuyển thành "Đã gửi CQT"
    
    @retry @limit
    Scenario: Giới hạn số lần gửi lại
      Given chứng từ có trạng thái "Gửi CQT lỗi"
      And đã gửi lại 3 lần
      When kế toán gửi lại lần thứ 4
      Then hệ thống hiển thị cảnh báo "Đã đạt giới hạn số lần gửi lại"
      And yêu cầu liên hệ hỗ trợ

  Rule: Bảo vệ chứng từ đã gửi CQT
    
    @protection
    Scenario: Không cho phép sửa chứng từ đã được CQT chấp nhận
      Given chứng từ có trạng thái "CQT chấp nhận"
      When kế toán cố chỉnh sửa chứng từ
      Then chứng từ không thể chỉnh sửa
      And thông báo "Chứng từ đã được CQT chấp nhận, không thể chỉnh sửa" được hiển thị
    
    @protection
    Scenario: Không cho phép xóa chứng từ đã được CQT chấp nhận
      Given chứng từ có trạng thái "CQT chấp nhận"
      When kế toán cố xóa chứng từ
      Then chứng từ không thể xóa
      And thông báo "Chứng từ đã được CQT chấp nhận, không thể xóa" được hiển thị
    
    @protection
    Scenario: Không cho phép sửa chứng từ CQT kiểm tra không hợp lệ
      Given chứng từ có trạng thái "CQT kiểm tra không hợp lệ"
      When kế toán cố chỉnh sửa chứng từ
      Then chứng từ không thể chỉnh sửa
      And thông báo "Chứng từ bị CQT từ chối, vui lòng lập chứng từ mới" được hiển thị
    
    @protection
    Scenario: Không cho phép xóa chứng từ CQT kiểm tra không hợp lệ
      Given chứng từ có trạng thái "CQT kiểm tra không hợp lệ"
      When kế toán cố xóa chứng từ
      Then chứng từ không thể xóa
      And thông báo "Chứng từ bị CQT từ chối, không thể xóa" được hiển thị

  Rule: Lập chứng từ mới sau khi CQT từ chối
    
    @rejected @new-certificate
    Scenario: Lập chứng từ mới sau khi bị CQT từ chối
      Given chứng từ A có trạng thái "CQT kiểm tra không hợp lệ"
      And chi tiết lỗi từ CQT được hiển thị
      When kế toán lập chứng từ mới
      Then chứng từ mới B được tạo với trạng thái "Nháp"
      And chứng từ A vẫn giữ trạng thái "CQT kiểm tra không hợp lệ"
      And kế toán có thể tham khảo chi tiết lỗi từ chứng từ A
    
    @rejected @copy-data
    Scenario: Sao chép dữ liệu từ chứng từ bị từ chối
      Given chứng từ A có trạng thái "CQT kiểm tra không hợp lệ"
      When kế toán sao chép chứng từ A
      Then chứng từ mới B được tạo với dữ liệu từ chứng từ A
      And trạng thái chứng từ B là "Nháp"
      And kế toán có thể sửa dữ liệu trong chứng từ B
      And kế toán có thể xem chi tiết lỗi để sửa đúng
    
    @rejected @reference
    Scenario: Xem chi tiết lỗi từ chứng từ bị từ chối
      Given chứng từ có trạng thái "CQT kiểm tra không hợp lệ"
      When kế toán xem chi tiết chứng từ
      Then chi tiết lỗi từ CQT được hiển thị rõ ràng:
        | Mã lỗi | Trường lỗi      | Mô tả lỗi                    |
        | E001   | Mã số thuế      | Mã số thuế không đúng định dạng |
        | E002   | Họ và tên       | Họ và tên không được để trống   |
      And kế toán có thể tham khảo để lập chứng từ mới đúng
    
    @rejected @workflow
    Scenario: Luồng xử lý chứng từ bị từ chối
      Given chứng từ có trạng thái "CQT kiểm tra không hợp lệ"
      When kế toán xem chi tiết lỗi
      Then hệ thống hiển thị gợi ý "Lập chứng từ mới" hoặc "Sao chép để sửa"
      When kế toán chọn "Sao chép để sửa"
      Then chứng từ mới được tạo với dữ liệu từ chứng từ cũ
      And kế toán sửa theo chi tiết lỗi
      And kế toán phát hành chứng từ mới

  Rule: Hiệu năng

    @performance
    Scenario: Tính toán thuế nhanh
      Given kế toán nhập đầy đủ thông tin
      When hệ thống tính toán thuế
      Then kết quả được hiển thị trong vòng 1 giây

  Rule: Bảo mật

    @security
    Scenario: Kiểm tra quyền truy cập
      Given người dùng không có quyền quản lý chứng từ
      When người dùng cố truy cập chức năng lập chứng từ
      Then hệ thống từ chối truy cập

  Rule: Trải nghiệm người dùng

    @usability
    Scenario: Hiển thị gợi ý cho trường phức tạp
      Given kế toán đang lập chứng từ
      When kế toán di chuột qua trường phức tạp
      Then hệ thống hiển thị gợi ý

    @usability
    Scenario: Validation ngay lập tức
      Given kế toán đang nhập dữ liệu
      When kế toán nhập giá trị không hợp lệ
      Then lỗi được hiển thị ngay lập tức
