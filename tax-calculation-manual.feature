# language: vi
Feature: Nhập thông tin thuế thu nhập cá nhân khấu trừ
  Để ghi nhận thông tin thuế thu nhập đã khấu trừ
  Với vai trò kế toán
  Tôi cần nhập đầy đủ thông tin về khoản thu nhập và số thuế đã khấu trừ

  Background:
    Given kế toán đang lập chứng từ "Thông tin thuế thu nhập cá nhân khấu trừ"

  Rule: Nhập thông tin khoản thu nhập

    @income-info @input
    Scenario: Nhập các trường thông tin thu nhập
      Given kế toán đang ở phần "Thông tin thuế thu nhập cá nhân khấu trừ"
      When kế toán nhập thông tin:
        | Trường                        | Giá trị      |
        | Khoản thu nhập                | Tiền lương   |
        | Năm                           | 2025         |
        | Từ tháng                      | 1            |
        | Đến tháng                     | 12           |
        | Bảo hiểm                      | 3,150,000    |
        | Khoản từ thiện, nhân đạo      | 500,000      |
        | Quỹ hưu trí tự nguyện         | 1,000,000    |
        | Tổng thu nhập chịu thuế       | 30,000,000   |
        | Tổng thu nhập tính thuế       | 25,350,000   |
        | Số thuế                       | 3,602,500    |
      Then thông tin được lưu vào chứng từ

    @income-info @validation
    Scenario: Yêu cầu nhập các trường bắt buộc
      Given kế toán đang nhập thông tin thuế
      And trường "Khoản thu nhập" để trống
      When kế toán lưu chứng từ
      Then hệ thống hiển thị lỗi "Khoản thu nhập không được để trống"

    @income-info @validation
    Scenario: Yêu cầu chọn khoảng thời gian hợp lệ
      Given kế toán đang nhập thông tin thuế
      And "Từ tháng" là 5
      When kế toán chọn "Đến tháng" là 3
      Then hệ thống hiển thị lỗi "Đến tháng phải lớn hơn hoặc bằng Từ tháng"

    @income-info @validation
    Scenario Outline: Kiểm tra định dạng số tiền
      Given kế toán đang nhập thông tin thuế
      When kế toán nhập "<field>" với giá trị "<value>"
      Then hệ thống <result>

      Examples:
        | field                     | value       | result                                    |
        | Bảo hiểm                  | 3150000     | chấp nhận giá trị                         |
        | Tổng thu nhập chịu thuế   | 30,000,000  | chấp nhận giá trị                         |
        | Số thuế                   | -1000       | hiển thị lỗi "Số tiền phải lớn hơn 0"     |
        | Bảo hiểm                  | abc         | hiển thị lỗi "Số tiền không đúng định dạng"|

  Rule: Hỗ trợ tham khảo công thức tính

    @calculation-guide @reference
    Scenario: Hiển thị công thức tính thuế tham khảo
      Given kế toán đang nhập thông tin thuế
      When kế toán nhấn vào biểu tượng "Hướng dẫn tính" bên cạnh trường "Tổng thu nhập tính thuế"
      Then hệ thống hiển thị công thức tham khảo:
        """
        Thu nhập tính thuế = Thu nhập chịu thuế - Bảo hiểm - Khoản từ thiện - Quỹ hưu trí tự nguyện
        
        LƯU Ý: Kế toán cần tự tính toán và nhập kết quả vào hệ thống
        """

    @calculation-guide @tax-table
    Scenario: Hiển thị biểu thuế lũy tiến tham khảo
      Given kế toán đang nhập thông tin thuế
      When kế toán nhấn vào biểu tượng "Bảng thuế" bên cạnh trường "Số thuế"
      Then hệ thống hiển thị biểu thuế TNCN lũy tiến 7 bậc:
        | Bậc | Thu nhập tính thuế (VNĐ/tháng) | Thuế suất |
        | 1   | Đến 5 triệu                    | 5%        |
        | 2   | Trên 5 triệu đến 10 triệu      | 10%       |
        | 3   | Trên 10 triệu đến 18 triệu     | 15%       |
        | 4   | Trên 18 triệu đến 32 triệu     | 20%       |
        | 5   | Trên 32 triệu đến 52 triệu     | 25%       |
        | 6   | Trên 52 triệu đến 80 triệu     | 30%       |
        | 7   | Trên 80 triệu                  | 35%       |

    @calculation-guide @example
    Scenario: Hiển thị ví dụ tính thuế
      Given kế toán đang nhập thông tin thuế
      When kế toán nhấn vào "Xem ví dụ tính thuế"
      Then hệ thống hiển thị ví dụ:
        """
        Ví dụ:
        - Thu nhập chịu thuế: 30,000,000 VNĐ
        - Bảo hiểm: 3,150,000 VNĐ
        - Khoản từ thiện: 500,000 VNĐ
        - Quỹ hưu trí tự nguyện: 1,000,000 VNĐ
        
        Thu nhập tính thuế = 30,000,000 - 3,150,000 - 500,000 - 1,000,000 = 25,350,000 VNĐ
        
        Tính thuế theo biểu lũy tiến:
        - 5,000,000 × 5% = 250,000
        - 5,000,000 × 10% = 500,000
        - 8,000,000 × 15% = 1,200,000
        - 7,350,000 × 20% = 1,470,000
        
        Tổng số thuế = 3,420,000 VNĐ
        """

  Rule: Nhập thông tin cho nhiều tháng

    @multi-month @input
    Scenario: Nhập thông tin cho khoảng thời gian
      Given kế toán đang nhập thông tin thuế
      When kế toán chọn:
        | Từ tháng | 1    |
        | Đến tháng| 12   |
        | Năm      | 2025 |
      And kế toán nhập các thông tin thu nhập và thuế
      Then thông tin được áp dụng cho cả 12 tháng từ 1/2025 đến 12/2025

    @multi-month @display
    Scenario: Hiển thị thông tin theo tháng
      Given chứng từ có thông tin thuế từ tháng 1 đến tháng 12 năm 2025
      When kế toán xem chi tiết chứng từ
      Then hệ thống hiển thị thông tin theo từng tháng:
        | Tháng | Thu nhập chịu thuế | Bảo hiểm  | Thu nhập tính thuế | Số thuế   |
        | 1/25  | 30,000,000        | 3,150,000 | 26,850,000        | 3,827,500 |
        | 2/25  | 30,000,000        | 3,150,000 | 26,850,000        | 3,827,500 |
        | ...   | ...               | ...       | ...               | ...       |
        | 12/25 | 30,000,000        | 3,150,000 | 26,850,000        | 3,827,500 |

  Rule: Sao chép thông tin từ tháng trước

    @copy @convenience
    Scenario: Sao chép thông tin khoản thu nhập từ chứng từ trước
      Given đã có chứng từ tháng 11/2025 với thông tin thuế
      When kế toán lập chứng từ mới cho tháng 12/2025
      And kế toán chọn "Sao chép từ chứng từ trước"
      Then hệ thống điền sẵn thông tin từ chứng từ tháng 11/2025
      And kế toán có thể chỉnh sửa các thông tin đã được điền

    @copy @reference
    Scenario: Xem thông tin tháng trước để tham khảo
      Given kế toán đang lập chứng từ mới
      When kế toán nhấn "Xem chứng từ tháng trước"
      Then hệ thống hiển thị chứng từ gần nhất đã lập
      And kế toán có thể tham khảo các số liệu để nhập

  Rule: Kiểm tra tính hợp lý của dữ liệu

    @validation @logic
    Scenario: Cảnh báo khi thu nhập tính thuế lớn hơn thu nhập chịu thuế
      Given kế toán đang nhập thông tin thuế
      And "Tổng thu nhập chịu thuế" là 30,000,000 VNĐ
      When kế toán nhập "Tổng thu nhập tính thuế" là 35,000,000 VNĐ
      Then hệ thống hiển thị cảnh báo "Thu nhập tính thuế không nên lớn hơn thu nhập chịu thuế"
      And cho phép kế toán tiếp tục nếu chắc chắn

    @validation @logic
    Scenario: Cảnh báo khi số thuế quá cao so với thu nhập tính thuế
      Given kế toán đang nhập thông tin thuế
      And "Tổng thu nhập tính thuế" là 25,000,000 VNĐ
      When kế toán nhập "Số thuế" là 10,000,000 VNĐ
      Then hệ thống hiển thị cảnh báo "Số thuế cao bất thường (>35% thu nhập tính thuế)"
      And yêu cầu kế toán kiểm tra lại

    @validation @logic
    Scenario: Cảnh báo khi tổng các khoản khấu trừ lớn hơn thu nhập chịu thuế
      Given kế toán đang nhập thông tin thuế
      And "Tổng thu nhập chịu thuế" là 10,000,000 VNĐ
      When kế toán nhập:
        | Bảo hiểm              | 8,000,000 |
        | Khoản từ thiện        | 3,000,000 |
        | Quỹ hưu trí tự nguyện | 1,000,000 |
      Then hệ thống hiển thị cảnh báo "Tổng các khoản khấu trừ (12,000,000 VNĐ) lớn hơn thu nhập chịu thuế"
      And gợi ý "Thu nhập tính thuế nên là 0 VNĐ"

  Rule: Lưu và chỉnh sửa thông tin

    @save @draft
    Scenario: Lưu nháp khi chưa nhập đủ thông tin
      Given kế toán đang nhập thông tin thuế
      And một số trường bắt buộc chưa được nhập
      When kế toán chọn "Lưu nháp"
      Then chứng từ được lưu với trạng thái "Nháp"
      And kế toán có thể quay lại tiếp tục nhập sau

    @save @validate
    Scenario: Kiểm tra đầy đủ thông tin khi phát hành
      Given kế toán đã nhập thông tin thuế
      And còn trường bắt buộc chưa điền
      When kế toán chọn "Phát hành"
      Then hệ thống hiển thị danh sách các trường cần bổ sung
      And không cho phép phát hành

    @edit @correction
    Scenario: Sửa thông tin khi phát hiện sai sót
      Given chứng từ có trạng thái "Nháp"
      When kế toán sửa "Số thuế" từ 3,827,500 thành 3,602,500
      And kế toán lưu chứng từ
      Then thông tin "Số thuế" được cập nhật thành 3,602,500 VNĐ
