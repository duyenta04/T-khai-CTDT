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

  Rule: Kiểm tra tính hợp lý của dữ liệu

    @validation @logic
    Scenario: Cảnh báo khi thu nhập tính thuế lớn hơn thu nhập chịu thuế
      Given kế toán đang nhập thông tin thuế
      And "Tổng thu nhập chịu thuế" là 30,000,000 VNĐ
      When kế toán nhập "Tổng thu nhập tính thuế" là 35,000,000 VNĐ
      Then hệ thống hiển thị cảnh báo "Thu nhập tính thuế không nên lớn hơn thu nhập chịu thuế"
      And cho phép kế toán tiếp tục nếu chắc chắn

  Rule: Lưu nháp

    @save @draft
    Scenario: Lưu nháp khi chưa nhập đủ thông tin
      Given kế toán đang nhập thông tin thuế
      And một số trường bắt buộc chưa được nhập
      When kế toán chọn "Ghi tạm"
      Then chứng từ được lưu với trạng thái "Nháp"
      And kế toán có thể quay lại tiếp tục chỉnh sửa

   Rule: Xem trước chứng từ

    @preview @display
    Scenario: Xem trước chứng từ trước khi phát hành
      Given kế toán đã nhập đầy đủ thông tin thuế
      When kế toán chọn "Xem trước"
      Then hệ thống hiển thị bản xem trước chứng từ theo mẫu mặc định của năm hiện tại

    @save @validate
    Scenario: Kiểm tra đầy đủ thông tin khi phát hành
      Given kế toán đã nhập thông tin thuế
      And còn trường bắt buộc chưa điền
      When kế toán chọn "Phát hành"
      Then hệ thống hiển thị danh sách các trường cần bổ sung
      And không cho phép phát hành

