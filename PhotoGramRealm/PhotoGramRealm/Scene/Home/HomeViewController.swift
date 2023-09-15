//
//  HomeViewController.swift
//  PhotoGramRealm
//
//  Created by jack on 2023/09/03.
//

import UIKit
import SnapKit
import RealmSwift

class HomeViewController: BaseViewController {
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.rowHeight = 100
        view.delegate = self
        view.dataSource = self
        view.register(PhotoListTableViewCell.self, forCellReuseIdentifier: PhotoListTableViewCell.reuseIdentifier)
        return view
    }()
    
    var tasks: Results<DiaryTable>!
    
    //Realm Read
    //    let realm = try! Realm()  //default.realm까지 접근
    
    let repository = DiaryTableRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tasks = repository.fetch()
        repository.checkSchemaVersion()
        print(tasks)
//                print(realm.configuration.fileURL) // 레포지토리 메서드로 만들기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        
    }
    override func configure() {
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusButtonClicked))
        
        let sortButton = UIBarButtonItem(title: "정렬", style: .plain, target: self, action: #selector(sortButtonClicked))
        let filterButton = UIBarButtonItem(title: "필터", style: .plain, target: self, action: #selector(filterButtonClicked))
        let backupButton = UIBarButtonItem(title: "백업", style: .plain, target: self, action: #selector(backupButtonClicked))
        navigationItem.leftBarButtonItems = [sortButton, filterButton, backupButton]
    }
    
    override func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    @objc func plusButtonClicked() {
        navigationController?.pushViewController(AddViewController(), animated: true)
    }
    
    @objc func backupButtonClicked() {
        navigationController?.pushViewController(BackupViewController(), animated: true)
    }
    
    
    @objc func sortButtonClicked() {
        
    }
    
    @objc func filterButtonClicked() {
        
        //        let result = realm.objects(DiaryTable.self).where {
        // 1. 대소문자 구별 없음 - caseInsensitive
        //            $0.diaryTitle.contains("제목", options: .caseInsensitive)
        
        //2. Bool
        //            $0.diaryLike == true
        
        //3. 사진이 있는 데이터만 불러오기 (dailyPhoto의 nil 여부 판단) 100개만 필요하다고 하면 애초에 100개만 가져옴          애플에서 제공하는 필터는 3만개를 가져와서 100개를 보여준다.
        //            $0.diaryPhoto != nil
        tasks = repository.fetchFilter()
        
        
        tableView.reloadData()
        
        
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoListTableViewCell.reuseIdentifier) as? PhotoListTableViewCell else { return UITableViewCell() }
        
        let data = tasks[indexPath.row]
        
        cell.titleLabel.text = data.diaryTitle
        cell.contentLabel.text = ""
        cell.dateLabel.text = "\(data.diaryDate)"
        //fileName은 똑같아야 한다.
        cell.diaryImageView.image = loadImageFromDocument(fileName: "han_\(data._id).jpg")
        
        
        //        let value = URL(string: data.diaryPhoto ?? "")
        //
        //        //String -> URL -> Dat -> UIImage
        //        // 1. 셀 서버통신 - 용량이 클 때는 모두가 오래 걸린다.
        //        // 2. 이미지를 미리 UIImage 형식으로 반환하고 , 셀에서 UIImage를 바로 보여주자!
        //        //  => 재사용 메커니즘을 효율적으로 사용하지 못할 수 도 있고, UIImage 배열 구성 자체가 오래 걸릴 수 있음
        //        DispatchQueue.global().async {
        //            if let url = value, let data = try? Data(contentsOf: url ) {
        //                // 데이터베이스에서 가져오는데 global에서 가져오려고 하니까 오류가 생긴다.
        //                DispatchQueue.main.async {
        //                    cell.diaryImageView.image = UIImage(data: data)
        //                }
        //            }
        //        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let vc = DetailViewController()
        vc.data = tasks[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
        
        
        //Realm Delete
        //        let data = tasks[indexPath.row]
        //        removeImageFromDocument(fileName: "han_\(data._id).jpg")
        //        // 테이블셀은 삭제되지만 저장된 사진이 남아있다. 용량이 계속 쌓인다.
        //        try! realm.write {
        //            realm.delete(data)
        //        }
        //
        //        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let like = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            print("좋아요 선택됨")
        }
        let sample = UIContextualAction(style: .normal, title: "테스트") { action, view, completionHandler in
            print("테스트 선택됨")
        }
        
        like.backgroundColor = .orange
        like.image = tasks[indexPath.row].diaryLike ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        
        return UISwipeActionsConfiguration(actions: [like, sample])
    }
    
    
    
    
    
    
}



