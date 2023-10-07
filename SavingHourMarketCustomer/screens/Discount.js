/* eslint-disable prettier/prettier */
// eslint-disable-next-line prettier/prettier
import React, {useState, useEffect, useCallback} from 'react';
import {
  Text,
  View,
  TouchableOpacity,
  Image,
  StyleSheet,
  FlatList,
} from 'react-native';
import {icons} from '../constants';
import {COLORS, FONTS} from '../constants/theme';
import Categories from '../components/Categories';
import dayjs from 'dayjs';
import {API} from '../constants/api';
import {useFocusEffect} from '@react-navigation/native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import Empty from '../assets/image/search-empty.png';

const Discount = ({navigation}) => {
  const [discounts, setDiscounts] = useState([]);
  const [categories, setCategories] = useState([]);
  const [currentCate, setCurrentCate] = useState('');
  const [cartList, setCartList] = useState([]);
  const [products, setProducts] = useState([]);

  useFocusEffect(
    useCallback(() => {
      (async () => {
        try {
          const cartList = await AsyncStorage.getItem('CartList');
          setCartList(cartList ? JSON.parse(cartList) : []);
        } catch (err) {
          console.log(err);
        }
      })();
    }, []),
  );

  useEffect(() => {
    fetch(`${API.baseURL}/api/product/getAllCategory`)
      .then(res => res.json())
      .then(data => {
        setCategories(data);
        setCurrentCate(data[0].id);
      })
      .catch(err => {
        console.log(err);
      });
  }, []);

  useEffect(() => {
    if (currentCate) {
      fetch(
        `${API.baseURL}/api/discount/getDiscountsForCustomer?fromPercentage=0&toPercentage=100&productCategoryId=${currentCate}&page=0&limit=5&expiredSortType=ASC`,
      )
        .then(res => res.json())
        .then(data => {
          setDiscounts(data);
        })
        .catch(err => {
          console.log(err);
        });

      fetch(
        `${API.baseURL}/api/product/getProductsForCustomer?productCategoryId=${currentCate}&page=0&limit=5&quantitySortType=DESC&expiredSortType=ASC`,
      )
        .then(res => res.json())
        .then(data => {
          setProducts(data);
        })
        .catch(err => {
          console.log(err);
        });
    }
  }, [currentCate]);

  const Item = ({data}) => (
    <View style={styles.itemContainer}>
      {/* Image Product */}
      <Image
        resizeMode="contain"
        source={{
          uri: data?.imageUrl,
        }}
        style={styles.itemImage}
      />

      <View style={{justifyContent: 'center', flex: 1, marginRight: 10}}>
        <Text
          numberOfLines={1}
          style={{
            fontFamily: FONTS.fontFamily,
            fontSize: 18,
            fontWeight: 700,
            maxWidth: '95%',
            color: 'black',
          }}>
          {data.name}
        </Text>

        <Text
          style={{
            fontFamily: FONTS.fontFamily,
            fontSize: 18,
            marginBottom: 10,
          }}>
          HSD: {dayjs(data.expiredDate).format('DD/MM/YYYY')}
        </Text>
        {/* Button use */}
        <TouchableOpacity
          onPress={() =>
            navigation.navigate('DiscountForCategories', {
              discount: data,
              products: products,
            })
          }>
          <Text
            style={{
              maxWidth: 120,
              maxHeight: 38,
              padding: 10,
              backgroundColor: COLORS.primary,
              borderRadius: 10,
              textAlign: 'center',
              color: '#ffffff',
            }}>
            Dùng ngay
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
  return (
    <View>
      <View
        style={{
          flexDirection: 'row',
          alignItems: 'center',
          justifyContent: 'space-between',
          marginVertical: 15,
          marginHorizontal: 15,
        }}>
        <TouchableOpacity onPress={() => navigation.goBack()}>
          <Image
            source={icons.leftArrow}
            resizeMode="contain"
            style={{width: 35, height: 35, tintColor: COLORS.primary}}
          />
        </TouchableOpacity>
        <Text
          style={{
            textAlign: 'center',
            color: 'black',
            fontSize: 24,
            fontFamily: FONTS.fontFamily,
          }}>
          Mã giảm giá
        </Text>
        <TouchableOpacity
          onPress={() => {
            navigation.navigate('Cart');
          }}>
          <Image
            resizeMode="contain"
            style={{
              height: 40,
              tintColor: COLORS.primary,
              width: 35,
            }}
            source={icons.cart}
          />
          {cartList.length !== 0 && (
            <View
              style={{
                position: 'absolute',
                top: 0,
                right: -10,
                backgroundColor: COLORS.primary,
                borderRadius: 50,
                width: 20,
                height: 20,
                alignItems: 'center',
                justifyContent: 'center',
              }}>
              <Text
                style={{fontSize: 12, color: 'white', fontFamily: 'Roboto'}}>
                {cartList.length}
              </Text>
            </View>
          )}
        </TouchableOpacity>
      </View>
      {/* Filter by Cate */}
      <Categories
        categories={categories}
        currentCate={currentCate}
        setCurrentCate={setCurrentCate}
      />
      {/* List voucher */}
      {discounts.length == 0 ? (
        <View style={{alignItems: 'center'}}>
          <Image
            style={{width: '100%', height: '65%'}}
            resizeMode="contain"
            source={Empty}
          />
          <Text
            style={{
              fontSize: 20,
              fontFamily: 'Roboto',
              fontWeight: 'bold',
            }}>
            Đã hết mã giảm giá cho loại mặt hàng này
          </Text>
        </View>
      ) : (
        <FlatList
          scrollEnabled={true}
          showsVerticalScrollIndicator={true}
          data={discounts}
          keyExtractor={item => `${item.id}`}
          renderItem={({item}) => <Item data={item} />}
        />
      )}
    </View>
  );
};

const styles = StyleSheet.create({
  itemContainer: {
    backgroundColor: '#ffffff',
    maxWidth: '90%',
    borderRadius: 20,
    marginHorizontal: '5%',
    marginBottom: 20,
    flexDirection: 'row',
  },
  itemImage: {
    width: 130,
    height: 130,
    borderRadius: 20,
    padding: 10,
    margin: 15,
  },
  itemText: {
    fontFamily: FONTS.fontFamily,
    fontSize: 20,
  },
});

export default Discount;
