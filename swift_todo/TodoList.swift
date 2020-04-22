//
//  TodoList.swift
//  swift_todo
//
//  Created by Macro on 2020/4/22.
//  Copyright © 2020 Macro. All rights reserved.
//

import SwiftUI

// 待办列表数组
var exampletodos: [Todo] = [
    Todo(title: "1", dueDate: Date()),
    Todo(title: "2", dueDate: Date()),
]

struct TodoList: View {
    @ObservedObject var main: Main
    
    var body: some View {
        // app标题
        NavigationView {
            // 滚动查看
            ScrollView {
                // 遍历用户的待办
                ForEach(main.todos) { todo in
                    VStack {
                        // 如果当前待办日期不等于上一个待办的日期就显示
                        if todo.id == 0 || formatter.string(from: self.main.todos[todo.id].dueDate) != formatter.string(from: self.main.todos[todo.id - 1].dueDate) {
                            HStack {
                                Spacer()
                                    .frame(width: 30)
                                // 日期转换成中文
                                Text(date2Word(date: self.main.todos[todo.id].dueDate))
                                Spacer()
                            }
                        }
                        HStack {
                            Spacer()
                                .frame(width: 20)
                            TodoItem(main: self.main, todoIndex: .constant(todo.id))
                                // 圆角
                                .cornerRadius(10)
                                // 会认为TodoItem&cornerRadius是一个整体
                                .clipped()
                                // 阴影
                                .shadow(color: Color("todoItemShadow"), radius: 5)
                            Spacer()
                                .frame(width: 20)

                        }
                        Spacer()
                            .frame(height: 20)
                    }
                }
                Spacer()
                    .frame(height: 150)
            }
            // 适配机型
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle(Text("待办事项")
                .foregroundColor(Color("theme")))
            // 更新数据
            .onAppear {
                // 从UserDefaults读取数据,变成Data数据类型
                if let data = UserDefaults.standard.object(forKey: "todos") as? Data {
                    // 如果获取数据成功,如果成功解压数据就变成空列表
                    let todolist = NSKeyedUnarchiver.unarchiveObject(with: data) as? [Todo] ?? []
                    for todo in todolist {
                        // 如果待办没打勾
                        if !todo.checked {
                            self.main.todos.append(todo)
                        }
                    }
                    self.main.sort()
                } else {
                    // 如果没成功解压就显示exampletodos
                    self.main.todos = exampletodos
                    self.main.sort()
                }
            }
        }
    }
}

struct TodoList_Previews: PreviewProvider {
    static var previews: some View {
        TodoList(main: Main())
    }
}
