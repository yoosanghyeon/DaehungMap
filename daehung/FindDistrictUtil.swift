//
//  FindDistrictUtil.swift
//  daehung
//
//  Created by 유상현 on 2018. 9. 26..
//  Copyright © 2018년 유상현. All rights reserved.
//

import Foundation

class FindDistrictUitl{
    
    func FindDistrict(_ district : String) -> Int {
        var reuslt = 0;
        switch district {
        case "종로구":
            reuslt = 10
            break
        case "중구":
            reuslt = 11
            break
        case "마포구":
            reuslt = 12
            break
        case "서대문구":
            reuslt = 13
            break
        case "성동구":
            reuslt = 14
            break
        case "광진구":
            reuslt = 15
            break
        case "동대문구":
            reuslt = 16
            break
        case "영등포구":
            reuslt = 17
            break
        case "양천구":
            reuslt = 18
            break
        case "용산구":
            reuslt = 19
            break
        case "은평구":
            reuslt = 20
            break
        case "강동구":
            reuslt = 21
            break
        case "강서구":
            reuslt = 22
            break
        case "송파구":
            reuslt = 23
            break
        case "성북구":
            reuslt = 25
            break
        case "노원구":
            reuslt = 26
            break
        case "도봉구":
            reuslt = 27
            break
        case "금천구":
            reuslt = 28
            break
        case "구로구":
            reuslt = 29
            break
        case "동작구":
            reuslt = 30
            break
        case "관악구":
            reuslt = 31
            break
        case "서초구":
            reuslt = 32
            break
        case "강남구":
            reuslt = 33
            break
        case "강북구":
            reuslt = 34
            break
        default:
            reuslt = 0
        }
        return reuslt
    }
}
