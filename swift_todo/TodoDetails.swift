//
//  TodoDetails.swift
//  swift_todo
//
//  Created by Macro on 2020/4/22.
//  Copyright © 2020 Macro. All rights reserved.
//

import SwiftUI

struct TodoDetails: View {
    @ObservedObject var main: Main
    @State var confirmingCancel: Bool = false
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    if confirmingCancel {
                        Button(action: {
                            self.confirmingCancel = false
                        }) {
                            Text("继续编辑")
                                .padding()
                        }
                        Button(action: {
                            UIApplication.shared.keyWindow?.endEditing(true)
                            self.confirmingCancel = false
                            self.main.detailsShowing = false
                        }) {
                            Text("放弃修改")
                                .padding()
                        }
                    } else {
                        Button(action: {
                            if (!editingMode && self.main.detailsTitle == "" ||
                                editingMode && editingTodo.title == self.main.detailsTitle &&
                                editingTodo.dueDate == self.main.detailsDueDate) {
                                UIApplication.shared.keyWindow?.endEditing(true)
                                self.main.detailsShowing = false
                            } else {
                                self.confirmingCancel = true
                            }
                        }) {
                            Text("取消")
                                .padding()
                        }
                    }
                    Spacer()
                    if !confirmingCancel {
                        Button(action: {
                            // 收起键盘
                            UIApplication.shared.keyWindow?.endEditing(true)
                            // 如果正在编辑
                            if editingMode {
                                // 更新标题
                                self.main.todos[editingIndex].title = self.main.detailsTitle
                                // 更新时间
                                self.main.todos[editingIndex].dueDate = self.main.detailsDueDate
                            } else {
                                let newTodo = Todo(title: self.main.detailsTitle, dueDate: self.main.detailsDueDate)
                                newTodo.id = self.main.todos.count
                                // 添加到列表
                                self.main.todos.append(newTodo)
                            }
                            // 重新排序
                            self.main.sort()
                            do {
                                try UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: self.main.todos, requiringSecureCoding: false), forKey: "todos")
                            } catch {
                                print("error")
                            }
                            self.confirmingCancel = false
                            // 关掉编辑页面
                            self.main.detailsShowing = false
                        }) {
                            if editingMode {
                                Text("完成")
                                    .padding()
                            } else {
                                Text("添加")
                                    .padding()
                            }
                        // 为空时不允许添加待办，按钮变灰
                        }.disabled(main.detailsTitle == "")
                    }
                }
                // 第三方文本框
                SATextField(tag: 0, text: editingTodo.title, placeholder: "你要干哈", changeHandler: { (newString) in
                    self.main.detailsTitle = newString
                }) {
                }
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                .foregroundColor(.white)
                // 选题待办日期,变量前加$代表日期选择器更改后变量也会改
                DatePicker(selection: $main.detailsDueDate, displayedComponents: .date, label: { () -> EmptyView in
                })
                .padding()
                Spacer()
            }
            .padding()
            .background(Color("todoDetails-bg")
            .edgesIgnoringSafeArea(.all))
        }
    }
}

struct TodoDetails_Previews: PreviewProvider {
    static var previews: some View {
        TodoDetails(main: Main())
    }
}
