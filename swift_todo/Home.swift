//
//  Home.swift
//  swift_todo
//
//  Created by Macro on 2020/4/22.
//  Copyright © 2020 Macro. All rights reserved.
//

import SwiftUI

// 全局变量,存储当前状态
// 编辑模式
var editingMode: Bool = false
// 正在编辑的待办
var editingTodo: Todo = emptyToDo
// 第几个待办
var editingIndex: Int = 0
// 正在编辑，更新待办
var detailsShouldUpdateTitle: Bool = false

// 观察者模式，swifitui提供可实时更新ui
class Main: ObservableObject {
    @Published var todos: [Todo] = []
    // 是否弹出待办
    @Published var detailsShowing: Bool = false
    // 正在编辑文本框
    @Published var detailsTitle: String = ""
    // 时间
    @Published var detailsDueDate: Date = Date()
    
    // 排序待办列表
    func sort() {
        // 第一个的dueDate小于第二个,日期按远到近排序
        self.todos.sort(by: { $0.dueDate.timeIntervalSince1970 < $1.dueDate.timeIntervalSince1970 })
        // 更新todo里的id
        for id in 0 ..< self.todos.count {
            self.todos[id].id = id
        }
    }
}

struct Home: View {
    @ObservedObject var main: Main
    var body: some View {
        ZStack {
            TodoList(main: main)
                // 点击加号毛玻璃特效
                .blur(radius: main.detailsShowing ? 10 : 0)
                .animation(.spring())
            Button(action: {
                editingMode = false
                editingTodo = emptyToDo
                detailsShouldUpdateTitle = true
                self.main.detailsTitle = ""
                self.main.detailsDueDate = Date()
                self.main.detailsShowing = true
            }) {
                btnAdd()
            }
            .blur(radius: main.detailsShowing ? 10 : 0)
            // 偏移位置
            .offset(x: UIScreen.main.bounds.width/2 - 60, y: UIScreen.main.bounds.height/2 - 80)
            .animation(.spring())
            TodoDetails(main: main)
                .offset(x: 0, y: main.detailsShowing ? 0 : UIScreen.main.bounds.height)
        }
        
    }
}

// 浮动按钮
struct btnAdd: View {
    // 大小
    var size: CGFloat = 65.0
    var body: some View {
        // z轴排列
        ZStack {
            // 底层背景
            Group {
                Circle()
                    .fill(Color("btnAdd-bg"))
            }.frame(width: self.size, height: self.size)
                .shadow(color: Color("btnAdd-shadow"), radius: 10)
            // 加号图标
            Group {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(Color("theme"))
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home(main: Main())
    }
}
