//
//  NumberBaseball - main.swift
//  Created by yagom. 
//  Copyright © yagom academy. All rights reserved.
//

enum Const {
    static let tryCount: Int = 9
    static let initCount: Int = 0
    static let userInputCount: Int = 5
    static let userInputRemovedDuplicatedWhiteSpaces: Int = 4
    static let numberCount: Int = 3
    static let separator: String = " "
}

var computerRandomNumbers = Array<Int>(repeating: Const.initCount, count: Const.numberCount)
var userTryCount: Int = Const.tryCount

func chooseMenu() {
    var userInputNumber: String?
    while userInputNumber != "2" {
        print("1. 게임시작")
        print("2. 게임종료")
        print("원하는 기능을 선택해주세요 :", terminator: " ")
        userInputNumber = readLine()
        if let number = userInputNumber {
            checkUserChoice(userInput: number)
        }
    }
}

func checkUserChoice(userInput: String) {
    switch userInput {
    case "1":
        startGame()
    case "2":
        return
    default:
        print("입력이 잘못 되었습니다.")
    }
}

func startGame() {
    var userStrikeCount: Int = Const.initCount
    var userBallCount: Int = Const.initCount
    computerRandomNumbers = makeThreeRandomNumbers()
    userTryCount = Const.tryCount
    while userTryCount > Const.initCount && userStrikeCount < Const.numberCount {
        let validUserInput = startUserInput()
        userStrikeCount = Const.initCount
        userBallCount = Const.initCount
        (userStrikeCount, userBallCount) = checkBall(notStrikeNumbers: checkStrike(userStrikeCount: userStrikeCount, userNumbers: validUserInput), userBallCount: userBallCount)
        userTryCount -= 1
        printResult(userStrikeCount: userStrikeCount, userBallCount: userBallCount)
    }
}

func startUserInput() -> [Int] {
    var isValid: Bool = true
    var validNumbers: [Int] = []
    while isValid {
        printUserInputGuide()
        let userInput = convertUserInput()
        validNumbers = checkUserNumberFormat(userInput: userInput)
        if validNumbers.isEmpty == false {
            isValid = false
        }
    }
    return validNumbers
}

func printUserInputGuide() {
    print("숫자 3개를 띄어쓰기로 구분하여 입력해주세요.")
    print("중복 숫자는 허용하지 않습니다.")
    print("입력 ", terminator: "")
}

func makeThreeRandomNumbers() -> [Int] {
    var randomNumbers: Set<Int> = []
    while randomNumbers.count < Const.numberCount {
        randomNumbers.insert(Int.random(in: 1...9))
    }
    return Array(randomNumbers)
}

func convertUserInput() -> [String] {
    guard let userInput = readLine() else {
        return []
    }
    let userThreeNumbers = userInput.map { String($0) }
    return userThreeNumbers
}

func checkUserNumberFormat(userInput: [String]) -> [Int] {
    if isStringFormat(userInput: userInput),
        isThreeDigits(userInput: userInput),
        isSameCharacter(userInput: userInput) {
        return convertType(of: userInput)
    }
    return []
}

func isStringFormat(userInput: [String]) -> Bool {
    if userInput.isEmpty {
        return false
    }
    if userInput.count != Const.userInputCount {
        return false
    }
    if userInput[1] != Const.separator || userInput[3] != Const.separator {
        return false
    }
    return true
}

func isThreeDigits(userInput: [String]) -> Bool {
    let inputWithoutSpace: String = userInput.filter { $0 != Const.separator }.reduce("") { $0 + String($1) }
    guard let _ = Int(inputWithoutSpace) else {
        return false
    }
    if inputWithoutSpace.count != Const.numberCount ||
        inputWithoutSpace.contains(Character(String(Const.initCount))) {
        return false
    }
    return true
}

func isSameCharacter(userInput: [String]) -> Bool {
    if Set(userInput).count != Const.userInputRemovedDuplicatedWhiteSpaces {
        return false
    }
    return true
}

func convertType(of userInput: [String]) -> [Int] {
    let result: [Int] = userInput.compactMap {
        Int(String($0))
    }
    return result
}

func checkStrike(userStrikeCount: Int, userNumbers: [Int]) -> ([Int], Int) {
    var notStrikePossibleBallNumbers: [Int] = []
    var currentStrikeCount = userStrikeCount
    for (userIndex, userNumber) in userNumbers.enumerated() {
        if let (notStrikeNumber, strikeCount) = countStrike(userNumber: userNumber, userIndex: userIndex, userStrikeCount: currentStrikeCount) {
            currentStrikeCount = strikeCount
            notStrikePossibleBallNumbers.append(notStrikeNumber ?? Const.initCount)
        }
    }
    return (notStrikePossibleBallNumbers, currentStrikeCount)
}

func countStrike(userNumber: Int, userIndex: Int, userStrikeCount: Int) -> (Int?, Int)? {
    var strikeCount = userStrikeCount
    for (computerIndex, computerNumber) in computerRandomNumbers.enumerated() {
        if computerNumber == userNumber && computerIndex == userIndex {
            strikeCount += 1
            return (nil, strikeCount)
        }
    }
    return (userNumber, strikeCount)
}

func checkBall(notStrikeNumbers: (numbers: [Int], strikeCount: Int), userBallCount: Int) -> (Int, Int) {
    var ballCount = userBallCount
    for checkingNumber in notStrikeNumbers.numbers {
        ballCount = countBall(userNumber: checkingNumber, userBallCount: ballCount)
    }
    return (notStrikeNumbers.strikeCount, ballCount)
}

func countBall(userNumber: Int, userBallCount: Int) -> Int {
    var ballCount = userBallCount
    for computerNumber in computerRandomNumbers {
        if userNumber == computerNumber {
            ballCount += 1
        }
    }
    return ballCount
}

func printResult(userStrikeCount: Int, userBallCount: Int) {
    print("\(userStrikeCount) 스트라이크, \(userBallCount) 볼")
    print("남은 기회 : \(userTryCount)")
    printWinner(userStrikeCount: userStrikeCount)
}

func printWinner(userStrikeCount: Int) {
    if userStrikeCount == Const.numberCount {
        print("사용자 승리...!")
    }
    if userTryCount == Const.initCount {
        print("컴퓨터 승리...!")
    }
}

chooseMenu()
