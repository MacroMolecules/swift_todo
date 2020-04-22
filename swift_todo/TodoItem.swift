//
//  TodoItem.swift
//  swift_todo
//
//  Created by Macro on 2020/4/22.
//  Copyright © 2020 Macro. All rights reserved.
//

// 显示每一个待办事项,提供待办事项操作

import SwiftUI

// NSObject, NSCoding继承, 继承Identifiable特性
class Todo: NSObject, NSCoding, Identifiable {
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
    // @标签
    // 传入home里的main变量
    @ObservedObject var main: Main
    // 第几个待办的信息
    @Binding var todoIndex: Int
    // 待办打钩状态
    @State var checked: Bool = false
    
    // 界面
    var body: some View {
        // 左右排序
        HStack {
            // 左边按钮
            Button(action: {
                // 全局备份
                editingMode = true
                editingTodo = self.main.todos[self.todoIndex]
                editingIndex = self.todoIndex
                // 更新main
                self.main.detailsTitle = editingTodo.title
                self.main.detailsDueDate = editingTodo.dueDate
                self.main.detailsShowing = true
                detailsShouldUpdateTitle = true
            }) {
                HStack {
                    VStack {
                        // 左边小方块
                        Rectangle()
                            // 引用
                            .fill(Color("theme"))
                            .frame(width: 8)
                    }
                    // 空
                    Spacer()
                        .frame(width: 10)
                    // 待办信息
                    VStack {
                        Spacer()
                            .frame(height: 12)
                        // 标题
                        HStack {
                            Text(main.todos[todoIndex].title)
                                .font(Font.headline)
                                .foregroundColor(Color("todoItemTitle"))
                            Spacer()
                        }
                        Spacer()
                            .frame(height: 4)
                        HStack {
                            Image(systemName: "clock")
                                .resizable()
                                .frame(width: 12, height: 12)
                            // 从当前待办读日期
                            Text(formatter.string(from: main.todos[todoIndex].dueDate))
                                .font(Font.subheadline)
                            Spacer()
                        }.foregroundColor(Color("todoItemSubTitle"))
                        Spacer()
                            .frame(height: 12)
                    }
                }
            }
            // 右边打钩按钮
            Button(action: {
                // 当前待办是否打钩
                self.main.todos[self.todoIndex].checked.toggle()
                self.checked = self.main.todos[self.todoIndex].checked
                // 保存待办
                do {
                    // 报错不崩
                    let archivedData = try NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false)
                    // 存储用户数据swift提供
                    UserDefaults.standard.set(archivedData, forKey: "todos")
                } catch {
                    print("error")
                }
            }) {
                HStack {
                    Spacer()
                        .frame(width: 12)
                    VStack {
                        Spacer()
                        // 判断
                        Image(systemName: self.checked ? "checkmark.square.fill" : "square")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color.gray)
                        Spacer()
                    }
                    Spacer()
                        .frame(width: 12)

                }
            }.onAppear {
                // 刷新按钮状态
                self.checked = self.main.todos[self.todoIndex].checked
            }
        // 勾选后待办变换颜色,根据checked做判断
        }.background(Color(self.checked ? "todoItem-bg-checked" : "todoItem-bg"))
            // 动画效果
            .animation(Animation.spring())
    }
}

// 提供预览
struct TodoItem_Previews: PreviewProvider {
    static var previews: some View {
        TodoItem(main: Main(), todoIndex: .constant(0))
    }
}
