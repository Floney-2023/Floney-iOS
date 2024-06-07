//
//  CustomError.swift
//  Floney
//
//  Created by 남경민 on 2023/09/13.
//

import Foundation

protocol CustomError {
    var errorMessage: String { get }
}

enum ServerError: String, CustomError {
    case USER_FOUND = "U001"
    case NOT_AUTHENTICATED = "U002"
    case INVALID_MAIL_ADDRESS = "U003"
    case FAIL_TO_SEND_MAIL = "U004"
    case INVALID_AUTHENTICATION = "U005"
    case EXPIRED_JWT_TOKEN = "U006"
    case INVALID_JWT_TOKEN = "U007"
    case USER_NOT_FOUND = "U008"
    case INVALID_LOGIN = "U009"
    case USER_SIGNOUT = "U010"
    case INVALID_PROVIDER = "U011"
    case EMAIL_NOT_FOUND = "U012"
    case INVALID_CODE = "U013"
    case INVALID_EMAIL = "U014"
    case INVALID_OAUTH_RESPONSE = "U015"
    case INVALID_OAUTH_TOKEN = "U016"
    case SAME_PASSWORD = "U017"
    case CODE_INVALID = "U018"
    case OLD_PASSWORD_INVALID = "U022"
    case NOT_FOUND_BOOK = "B001"
    case MAX_MEMBER = "B002"
    case NOT_FOUND_CATEGORY = "B003"
    case NO_DELETE_BOOK = "B004"
    case NO_AUTHORITY = "B005"
    case NOT_FOUND_BOOK_USER = "B006"
    case NOT_FOUND_BOOK_LINE = "B007"
    case ALREADY_JOIN = "B008"
    case ALREADY_EXIST = "B011"
    case MAX_FAVORITE = "B014"
    case NOT_SUBSCRIBE = "S001"
    case LIMIT = "S002"
    case SETTLEMENT_NOT_FOUND = "ST001"
    case OUTCOME_USER_NOT_FOUND = "ST002"
    case SERVER_ERROR = "0"
        
    var errorMessage: String {
        switch self {
        case .USER_FOUND: // 이미 가입함
            return "이미 등록된 이메일 입니다."
        case .NOT_AUTHENTICATED: // 로그인 필요
            return "로그인이 필요합니다"
        case .INVALID_MAIL_ADDRESS: // 이메일이 존재하지 않음
            return "유효한 이메일을 입력해주세요."
        case .FAIL_TO_SEND_MAIL: // 메일 서버 에러
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .INVALID_AUTHENTICATION: // 인증 잘못됨
            return "다시 로그인 해주세요."
        case .EXPIRED_JWT_TOKEN:
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .INVALID_JWT_TOKEN:
            return "다시 로그인 해주세요."
        case .USER_NOT_FOUND:
            return "이메일 또는 비밀번호를 다시 확인하세요."
        case .INVALID_LOGIN: // U009
            return "이메일 또는 비밀번호를 다시 확인하세요."
        case .USER_SIGNOUT:
            return "탈퇴한 회원입니다."
        case .INVALID_PROVIDER:
            return "올바르지 않은 회원 유형입니다"
        case .EMAIL_NOT_FOUND: // U012 이메일이 존재하지 않습니다
            return "일치하는 회원이 없습니다."
        case .INVALID_CODE:
            return "코드가 올바르지 않습니다."
        case .INVALID_EMAIL:
            return "올바르지 않은 이메일입니다."
        case .INVALID_OAUTH_RESPONSE: //인증서버에서 받은 응답이 올바르지 않습니다
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .INVALID_OAUTH_TOKEN: //provider 토큰이 올바르지 않습니다
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .SAME_PASSWORD: //이전 비밀번호와 같습니다
            return "이전에 사용한 비밀번호 입니다."
        case .NOT_FOUND_BOOK: //가계부가 존재하지 않습니다
            return "해당 가계부는 존재하지 않습니다."
        case .MAX_MEMBER: //최대 인원이 초과되었습니다
            return "이미 사용자가 가득 찬 가계부 입니다."
        case .NOT_FOUND_CATEGORY: //카테고리가 존재하지 않습니다
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .NO_DELETE_BOOK: //남은 가계부 유저가 있습니다
            return "모든 사용자가 나가야 가계부 삭제가 가능합니다."
        case .NO_AUTHORITY: //가계부를 만든 사람만 삭제할 수 있습니다
            return "가계부를 만든 사람만 삭제할 수 있습니다"
        case .NOT_FOUND_BOOK_USER: //가계부 멤버를 찾을 수 없습니다
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .NOT_FOUND_BOOK_LINE:// 가계부 내역을 찾을 수 없습니다
            return "가계부 내역을 찾을 수 없습니다"
        case .ALREADY_JOIN: //이미 존재하는 가계부 유저입니다
            return "이미 가계부 멤버 입니다."
        case .NOT_SUBSCRIBE: //멤버쉽 전용 기능입니다
            return "멤버쉽 전용 기능입니다"
        case .LIMIT://제공하지 않는 서비스입니다
            return "이미 가계부 2개를 사용하고 있습니다."
        case .SETTLEMENT_NOT_FOUND: //정산 내역이 존재하지 않습니다
            return "내역이 없습니다. 기간을 다시 설정해주세요."
        case .OUTCOME_USER_NOT_FOUND: //지출 내역의 유저가 유저 목록에 존재하지 않습니다
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .SERVER_ERROR: // 서버 에러
            return "알 수 없는 오류입니다. 다시 시도해 주세요."
        case .CODE_INVALID: // 인증 코드 만료
            return "유효 시간이 초과되었습니다. 다시 시도해 주세요."
        case .ALREADY_EXIST:
            return "이미 존재하는 분류항목입니다."
        case .MAX_FAVORITE:
            return "즐겨찾기 개수가 초과되었습니다."
        case .OLD_PASSWORD_INVALID:
            return "현재 비밀번호를 확인해 주세요."
        }
    }
}

enum InputValidationError: CustomError {
    case emptyBookName
    case emptyNickname
    case checkPassword
    case passwordInvaid
    case emptyPasswordCheck
    case emptyPassword
    case emptyEmail
    case timeover
    case serviceAgreement
    case emailInvalid
    case textFieldEmpty
    case categoryNameEmpty
    case moneyEmpty
    case assetTypeEmpty
    case categoryTypeEmpty
    case bookCodeEmpty
    case onlyNumberValid
    case notSelectSignoutReason
    case noInputSignoutOtherReason
    var errorMessage: String {
        switch self {
        case .emailInvalid:
            return "유효하지 않은 이메일 형식입니다."
        case .textFieldEmpty:
            return "필드를 비워둘 수 없습니다."
        case .emptyBookName:
            return "이름을 입력하세요."
        case .emptyNickname:
            return "닉네임을 입력해주세요."
        case .checkPassword:
            return "비밀번호가 일치하지 않습니다."
        case .passwordInvaid:
            return "비밀번호 양식을 확인해주세요."
        case .emptyPasswordCheck:
            return "비밀번호 확인을 입력해주세요."
        case .emptyPassword:
            return "비밀번호를 입력해주세요."
        case .emptyEmail:
            return "이메일 주소를 입력해주세요."
        case .timeover:
            return "유효 시간이 초과되었습니다. 다시 시도해 주세요."
        case .serviceAgreement:
            return "필수 약관에 모두 동의해주세요."
        case .categoryNameEmpty:
            return "항목 이름을 입력해주세요."
        case .moneyEmpty:
            return "금액을 입력해주세요."
        case .assetTypeEmpty:
            return "자산을 선택해주세요."
        case .categoryTypeEmpty:
            return "분류를 선택해주세요."
        case .bookCodeEmpty:
            return "코드를 입력하세요."
        case .onlyNumberValid:
            return "숫자만 입력해주세요."
        case .notSelectSignoutReason:
            return "탈퇴 이유를 선택해주세요."
        case .noInputSignoutOtherReason:
            return "탈퇴 이유를 작성해주세요."
        }
        
    }
}

