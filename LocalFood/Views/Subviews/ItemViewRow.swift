//
//  ItemViewRow.swift
//  LocalFood
//
//  Created by Артем Хлопцев on 20.03.2022.
//

import SwiftUI
import SDWebImageSwiftUI
struct ItemViewRow: View {
    var item: ItemModel
    var body: some View {
        VStack {
            WebImage(url: URL(string: item.itemImage))
                .resizable()
                .scaledToFill()
                .frame(height: 250)
                .frame(maxWidth: UIScreen.main.bounds.width)
                .clipped()
            HStack(spacing: 8) {
                Text(item.itemName)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                Spacer(minLength: 0)
                
                // Rating
                ForEach(1..<6, id: \.self) {index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.itemRatings) ?? 0 ? .yellow : .gray)
                }
            }.padding(.bottom, 3)
            .padding(.horizontal, 7)

            HStack {
                Text(item.itemDetails)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Spacer(minLength: 0)
            }.padding(.horizontal, 7)

        }
            .padding(.bottom, 5)
    }
}

struct ItemViewRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemViewRow(item: ItemModel(id: "", itemName: "Lasagna", itemCost: 12, itemDetails:
                                        "Homemade lasagna is the best. It tastes nothing like the ones from the frozen food aisle. This recipe is so good—it’s the kind of lasagna people write home about! It brings together all of the things we love in a good pasta dish: noodles, cheeses, fresh herbs and a delicious meat sauce.", itemImage: "https://thestayathomechef.com/wp-content/uploads/2017/08/Most-Amazing-Lasagna-4-e1503516670834.jpg", itemRatings: "3"))
    }
}
