import SwiftUI
import PhotosUI

struct AdCarView: View {
    @StateObject private var viewModel = AdCarViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HeaderView(dismiss: dismiss, viewModel: viewModel)
            ContentView(viewModel: viewModel)
        }
        .background(Color.grayBackground)
        .navigationBarBackButtonHidden(true)
        .configureViewModifiers(viewModel: viewModel)
    }
}

// MARK: - Header Component
struct HeaderView: View {
    let dismiss: DismissAction
    @ObservedObject var viewModel: AdCarViewModel
    
    var body: some View {
        HStack {
            Button("Очистить") {
                viewModel.resetForm()
            }
            .foregroundColor(.blue)
            
            Spacer()
            
            Text("Новое объявление")
                .font(.headline)
            
            Spacer()
            
            Button("Закрыть") {
                dismiss()
            }
            .foregroundColor(.blue)
        }
        .padding()
    }
}

// MARK: - Main Content Component
struct ContentView: View {
    @ObservedObject var viewModel: AdCarViewModel
    @State private var photosPickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                CarTypeSection(viewModel: viewModel)
                ParametersSection(viewModel: viewModel)
                ConditionSection(viewModel: viewModel)
                DescriptionSection(viewModel: viewModel)
                PhotosSection(viewModel: viewModel, photosPickerItems: $photosPickerItems)
                PublishSection(viewModel: viewModel)
            }
            .padding(.vertical, 8)
        }
        .photosPicker(isPresented: .constant(false), selection: $photosPickerItems, maxSelectionCount: 30)
        .onChange(of: photosPickerItems) { newItems in
            Task {
                await handlePhotoSelection(newItems)
            }
        }
    }
    
    private func handlePhotoSelection(_ items: [PhotosPickerItem]) async {
        var images: [UIImage] = []
        for item in items {
            if let data = try? await item.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {
                images.append(image)
            }
        }
        viewModel.addImages(images)
        await MainActor.run {
            photosPickerItems.removeAll()
        }
    }
}

// MARK: - Car Type Section
struct CarTypeSection: View {
    @ObservedObject var viewModel: AdCarViewModel
    @State private var isShowingBrand = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle("Легковой автомобиль")
                .padding(.vertical)
            
            BrandSelectionButton(
                brand: viewModel.selectedBrand,
                model: viewModel.selectedModel,
                isShowingBrand: $isShowingBrand
            )
        }
        .sheet(isPresented: $isShowingBrand) {
            BrandSelectionView(viewModel: viewModel)
        }
    }
}

struct BrandSelectionButton: View {
    let brand: String
    let model: String
    @Binding var isShowingBrand: Bool
    
    var body: some View {
        Button(action: { isShowingBrand = true }) {
            HStack {
                VStack(alignment: .leading) {
                    if !brand.isEmpty && !model.isEmpty {
                        Text("Марка, модель")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                        Text("\(brand) \(model)")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                    } else {
                        Text("Марка, модель, поколение")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

// MARK: - Parameters Section
struct ParametersSection: View {
    @ObservedObject var viewModel: AdCarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle("Параметры")
                .padding(.vertical)
            
            VINSection(viewModel: viewModel)
        }
    }
}

struct VINSection: View {
    @ObservedObject var viewModel: AdCarViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("VIN-номер")
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(.black)
                .padding()
            
            VStack {
                TextField("Код из 17 символов", text: $viewModel.vin)
                    .padding()
                
                Divider()
                    .background(Color.gray)
                    .padding(.horizontal, 8)
                
                NavigationLink(destination: CategoryView()) {
                    HStack {
                        Text("Где искать VIN")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 8)
                }
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(.horizontal, 8)
            
            Text("Необязательно для транспорта старше 2000 г.\nНо мы рекомендуем заполнить это поле.\nОбъявления с указанным VIN привлекает внимание, повышает доверие к продавцу и обозначается специальной биркой [VIN]")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
    }
}

// MARK: - Condition Section
struct ConditionSection: View {
    @ObservedObject var viewModel: AdCarViewModel
    @State private var isShowingState = false
    @State private var isShowingMileage = false
    @State private var isShowingColor = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle("Состояние и цвет")
                .padding(.vertical)
            
            PickerButton(
                title: "Состояние",
                value: viewModel.selectedState,
                isShowingPicker: $isShowingState,
                emptyValue: StateAuto.none.rawValue
            )
            .sheet(isPresented: $isShowingState) {
                BottomSheetPicker(
                    selectedValue: $viewModel.selectedState,
                    values: StateAuto.allCases.map { $0.rawValue }.filter { !$0.isEmpty },
                    isPresented: $isShowingState,
                    title: "Состояние"
                )
            }
            
            MileageField(
                value: $viewModel.mileageValue,
                unit: $viewModel.mileageUnit,
                isShowingPicker: $isShowingMileage
            )
            .sheet(isPresented: $isShowingMileage) {
                BottomSheetPicker(
                    selectedValue: $viewModel.mileageUnit,
                    values: ["км", "миль"],
                    isPresented: $isShowingMileage,
                    title: "Пробег"
                )
            }
            
            PickerButton(
                title: "Цвет кузова",
                value: viewModel.color,
                isShowingPicker: $isShowingColor,
                emptyValue: ""
            )
            .sheet(isPresented: $isShowingColor) {
                BottomSheetPicker(
                    selectedValue: $viewModel.color,
                    values: ["белый", "бордовый", "желтый", "зеленый", "коричневый", "красный", "оранжевый", "серебристый", "серый", "синий", "фиолетовый", "черный", "другое"],
                    isPresented: $isShowingColor,
                    title: "Цвет кузова"
                )
            }
        }
    }
}

struct PickerButton: View {
    let title: String
    let value: String
    @Binding var isShowingPicker: Bool
    let emptyValue: String
    
    var body: some View {
        Button(action: { isShowingPicker = true }) {
            HStack {
                VStack(alignment: .leading) {
                    if value != emptyValue {
                        Text(title)
                            .font(.system(size: 14, weight: .regular))
                            .foregroundColor(.gray)
                        Text(value)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.black)
                    } else {
                        Text(title)
                            .font(.system(size: 16, weight: .regular))
                            .foregroundColor(.gray)
                    }
                }
                Spacer()
                Image(systemName: "chevron.down")
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

struct MileageField: View {
    @Binding var value: String
    @Binding var unit: String
    @Binding var isShowingPicker: Bool
    
    var body: some View {
        HStack {
            TextField("Пробег", text: $value)
                .keyboardType(.numberPad)
                .padding()
            
            Divider()
                .background(Color.gray)
            
            Button(action: { isShowingPicker = true }) {
                Text(unit)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

// MARK: - Description Section
struct DescriptionSection: View {
    @ObservedObject var viewModel: AdCarViewModel
    @State private var isShowingCurrency = false
    @State private var isShowingSwap = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle("Описание и цена")
                .padding(.vertical)
            
            DescriptionField(description: $viewModel.description)
            
            PriceField(
                price: $viewModel.price,
                currency: $viewModel.currency,
                isShowingPicker: $isShowingCurrency
            )
            .sheet(isPresented: $isShowingCurrency) {
                BottomSheetPicker(
                    selectedValue: $viewModel.currency,
                    values: ["USD", "BYN"],
                    isPresented: $isShowingCurrency,
                    title: "Валюта"
                )
            }
            
            PickerButton(
                title: "Обмен",
                value: viewModel.swapType,
                isShowingPicker: $isShowingSwap,
                emptyValue: ""
            )
            .sheet(isPresented: $isShowingSwap) {
                BottomSheetPicker(
                    selectedValue: $viewModel.swapType,
                    values: ["Не интересует", "Любой вариант", "С доплатой покупателя", "С доплатой продавца"],
                    isPresented: $isShowingSwap,
                    title: "Обмен"
                )
            }
        }
    }
}

struct DescriptionField: View {
    @Binding var description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("Описание", text: $description, axis: .vertical)
                .frame(minHeight: 120, alignment: .top)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .padding(.horizontal, 8)
            
            Text("Напишите пару теплых слов о вашем автомобиле")
                .font(.system(size: 14))
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
    }
}

struct PriceField: View {
    @Binding var price: String
    @Binding var currency: String
    @Binding var isShowingPicker: Bool
    
    var body: some View {
        HStack {
            TextField("Цена", text: $price)
                .keyboardType(.numberPad)
                .padding()
            
            Divider()
                .background(Color.gray)
            
            Button(action: { isShowingPicker = true }) {
                Text(currency)
                    .foregroundColor(.blue)
            }
            .padding(.horizontal)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 8)
    }
}

// MARK: - Photos Section
struct PhotosSection: View {
    @ObservedObject var viewModel: AdCarViewModel
    @Binding var photosPickerItems: [PhotosPickerItem]
    @State private var showingImagePicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionTitle("Фотографии")
                .padding(.vertical)
            
            VStack {
                HStack {
                    Text("Используйте только свои снимки\nи не размещайте рекламу. Иначе\nмодератор отклонит ваше объявление.")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    Spacer()
                }
                .padding()
                
                PhotosGridView(
                    images: viewModel.selectedImages,
                    onAdd: { showingImagePicker = true },
                    onRemove: viewModel.removeImage
                )
                .padding()
            }
            .background(Color.white)
            .cornerRadius(12)
            .padding(8)
        }
        .photosPicker(isPresented: $showingImagePicker, selection: $photosPickerItems, maxSelectionCount: 30)
    }
}

struct PhotosGridView: View {
    let images: [UIImage]
    let onAdd: () -> Void
    let onRemove: (Int) -> Void
    
    private let columns = Array(repeating: GridItem(.flexible()), count: 3)
    
    var body: some View {
        VStack {
        AddPhotoButton(onAdd: onAdd)
            LazyVGrid(columns: columns, spacing: 12) {
                
                ForEach(Array(images.enumerated()), id: \.offset) { index, image in
                    PhotoItem(image: image, index: index, onRemove: onRemove)
                }
                
            }
            .padding()
        }
    }
}

struct AddPhotoButton: View {
    let onAdd: () -> Void
    
    var body: some View {
        Button(action: onAdd) {
            VStack {
                Image(systemName: "camera.fill")
                    .font(.system(size: 30))
                    .foregroundColor(.blue)
                Text("Добавить")
                    .font(.caption)
                Text("до 30")
                    .font(.caption2)
                   // .foregroundColor(.gray)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(8)
        }
    }
}

struct PhotoItem: View {
    let image: UIImage
    let index: Int
    let onRemove: (Int) -> Void
    
    var body: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 100)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(8)
            
            Button(action: { onRemove(index) }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
                    .background(Color.clear)
            }
            .padding(4)
        }
    }
}

// MARK: - Publish Section
struct PublishSection: View {
    @ObservedObject var viewModel: AdCarViewModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Ознакомлен с правилами подачи объявлений. Согласен на размещение рекламного логотипа av.by на загруженные мной фотографии")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))
                    .padding(.trailing)
                
                RadioButton(title: "", isSelected: viewModel.isConfirm) {
                    viewModel.isConfirm.toggle()
                }
            }
            .padding()
            
            PublishButton(viewModel: viewModel)
                .padding(8)
        }
        .background(Color.white)
        .cornerRadius(12)
        .padding(8)
    }
}

struct PublishButton: View {
    @ObservedObject var viewModel: AdCarViewModel
    
    var body: some View {
        Button(action: {
            Task {
                do {
                    try await viewModel.publishAd()
                } catch {
                    print("Ошибка публикации: \(error)")
                }
            }
        }) {
            HStack {
                Spacer()
                if viewModel.isPublishing {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Опубликовать объявление")
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding()
        }
        .background(viewModel.isFormValid ? Color.blue : Color.gray)
        .cornerRadius(12)
        .disabled(!viewModel.isFormValid || viewModel.isPublishing)
    }
}

// MARK: - Helper Views
struct SectionTitle: View {
    let title: String
    
    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .font(.system(size: 24, weight: .semibold))
            .foregroundColor(.black)
            .padding(.horizontal)
    }
}

// MARK: - View Modifiers
extension View {
    func configureViewModifiers(viewModel: AdCarViewModel) -> some View {
        self
            .alert("Ошибка", isPresented: .constant(viewModel.error != nil)) {
                Button("OK", role: .cancel) {
                    viewModel.error = nil
                }
            } message: {
                if let error = viewModel.error {
                    Text(error)
                }
            }
    }
}

// MARK: - Brand Selection View
import SwiftUI

struct BrandSelectionView: View {
    @ObservedObject var viewModel: AdCarViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @FocusState private var isSearching: Bool
    @State private var selectedSegment = 0
    @State private var selectedLetter: String = "A"
    
    private let brandsByLetter: [String: [String]] = Brands.brandsByLetter
    
    private var filteredBrands: [String: [String]] {
        if searchText.isEmpty {
            return brandsByLetter
        } else {
            return brandsByLetter.mapValues {
                $0.filter { $0.localizedCaseInsensitiveContains(searchText) }
            }.filter { !$0.value.isEmpty }
        }
    }
    
    private let models: [String: [String]] = CarModel.models
    
    private let years = Array(1990...2024).reversed().map { String($0) }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: Header
                HStack {
                    Text("Выбор автомобиля")
                        .font(.system(size: 24, weight: .bold))
                    Spacer()
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.blueText)
                            .frame(width: 32, height: 32)
                            .background(Color(.systemGray5))
                            .cornerRadius(16)
                    }
                }
                .padding()
                
                // MARK: Search
                HStack {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Поиск марки", text: $searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                            .focused($isSearching)
                    }
                    .padding(10)
                    .frame(height: 40)
                    .background(.grayBackground)
                    .cornerRadius(10)
                    
                    if isSearching {
                        Button("Отмена") {
                            withAnimation(.easeInOut) {
                                searchText = ""
                                isSearching = false
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            }
                        }
                        .foregroundColor(.blue)
                        .padding(.leading, 8)
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
                
                // MARK: Alphabet index
                if searchText.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(filteredBrands.keys.sorted(), id: \.self) { letter in
                                Button {
                                    withAnimation(.easeInOut) {
                                        selectedLetter = letter
                                    }
                                } label: {
                                    Text(letter)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.blueText)
                                        .padding(8)
                                        .background(selectedLetter == letter ? Color.grayBackground : Color.clear)
                                        .cornerRadius(8)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
                
                // MARK: Selected Brand Info
                if !viewModel.selectedBrand.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Выбранная марка:")
                            .font(.headline)
                            .foregroundColor(.gray)
                        
                        HStack {
                            Text(viewModel.selectedBrand)
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Button("Изменить") {
                                viewModel.selectedBrand = ""
                                viewModel.selectedModel = ""
                                viewModel.selectedYear = ""
                            }
                            .foregroundColor(.blue)
                        }
                        
                        if !viewModel.selectedModel.isEmpty {
                            Text("Модель: \(viewModel.selectedModel)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        if !viewModel.selectedYear.isEmpty {
                            Text("Год: \(viewModel.selectedYear)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                    .background(Color.grayBackground)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
                
                // MARK: Content based on selection state
                if viewModel.selectedBrand.isEmpty {
                    // MARK: List of brands
                    ScrollViewReader { proxy in
                        List {
                            ForEach(filteredBrands.keys.sorted(), id: \.self) { letter in
                                Section(header: Text(letter).font(.headline)) {
                                    ForEach(filteredBrands[letter] ?? [], id: \.self) { brand in
                                        HStack {
                                            Text(brand)
                                            Spacer()
                                            if viewModel.selectedBrand == brand {
                                                Image(systemName: "checkmark")
                                                    .foregroundColor(.blue)
                                            }
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            viewModel.selectedBrand = brand
                                            viewModel.selectedModel = ""
                                            viewModel.selectedYear = ""
                                        }
                                    }
                                }
                                .id(letter)
                            }
                        }
                        .listStyle(.plain)
                        .onChange(of: selectedLetter) { newValue in
                            withAnimation(.easeInOut) {
                                proxy.scrollTo(newValue, anchor: .top)
                            }
                        }
                    }
                } else if viewModel.selectedModel.isEmpty {
                    // MARK: Model Selection
                    List {
                        Section(header: Text("Выберите модель")) {
                            if let brandModels = models[viewModel.selectedBrand] {
                                ForEach(brandModels, id: \.self) { model in
                                    HStack {
                                        Text(model)
                                        Spacer()
                                        if viewModel.selectedModel == model {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                        }
                                    }
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        viewModel.selectedModel = model
                                    }
                                }
                            } else {
                                Text("Модели не найдены")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .listStyle(.plain)
                } else {
                    // MARK: Year Selection
                    List {
                        Section(header: Text("Выберите год выпуска")) {
                            ForEach(years, id: \.self) { year in
                                HStack {
                                    Text(year)
                                    Spacer()
                                    if viewModel.selectedYear == year {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.blue)
                                    }
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    viewModel.selectedYear = year
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
                
                Spacer()
                
                // MARK: Bottom Buttons
                HStack {
                    Button {
                        viewModel.selectedBrand = ""
                        viewModel.selectedModel = ""
                        viewModel.selectedYear = ""
                    } label: {
                        Text("Сбросить")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    Button {
                        if !viewModel.selectedBrand.isEmpty && !viewModel.selectedModel.isEmpty && !viewModel.selectedYear.isEmpty {
                            dismiss()
                        }
                    } label: {
                        Text("Готово")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(canCompleteSelection ? .blue : .gray)
                    }
                    .disabled(!canCompleteSelection)
                }
                .padding(.horizontal)
                .padding(.vertical)
            }
            .background(Color.white)
            .navigationBarHidden(true)
        }
    }
    
    private var canCompleteSelection: Bool {
        !viewModel.selectedBrand.isEmpty && !viewModel.selectedModel.isEmpty && !viewModel.selectedYear.isEmpty
    }
}
#Preview {
    AdCarView()
}
