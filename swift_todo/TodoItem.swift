//
//  TodoItem.swift
//  swift_todo
//
//  Created by Macro on 2020/4/22.
//  Copyright © 2020 Macro. All rights reserved.
//

// 显示每一个待办事项,提供待办事项操作

import SwiftUI

// NSObject, NSCoding继承
class Todo: NSObject, NSCoding {
    // 打包成可存储格式
    func encode(with coder: NSCoder) {
        // forKey存储的关键词
        coder.encode(self.title, forKey: "title")
        coder.encode(self.dueDate, forKey: "dueDate")
        coder.encode(self.checked, forKey: "checked")
    }
    
    // 解压
    required init?(coder: NSCoder) {
        // as字符串转换
        self.title = coder.decodeObject(forKey: "title") as? String ?? ""
        self.dueDate = coder.decodeObject(forKey: "dueDate") as? Date ?? Date()
        self.checked = coder.decodeBool(forKey: "checked")
    }
    
    // 标题
    var title: String = ""
    // 时间,存日期
    var dueDate: Date = Date()
    // 是否完成
    var checked: Bool = false
    // 记录列表里的第几个待办
    var id: Int = 0
    
    // 初始化
    init(title: String, dueDate: Date) {
        self.title = title
        self.dueDate = dueDate
    }
}

// 一个新的空todo
var emptyToDo: Todo = Todo(title: "", dueDate: Date())

struct TodoItem: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct TodoItem_Previews: PreviewProvider {
    static var previews: some View {
        TodoItem()
    }
}
