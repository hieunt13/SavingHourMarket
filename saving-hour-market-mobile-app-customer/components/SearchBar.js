/* eslint-disable prettier/prettier */
import React from 'react';
import {
  Text,
  View,
  TouchableOpacity,
  TextInput,
  StyleSheet,
  Image,
} from 'react-native';
import { COLORS, FONTS } from '../constants/theme';
import { icons } from '../constants';
import { useState } from 'react';

const SearchBar = ({
  navigation,
  text,
  setText,
  handleTypingSearch,
  result,
}) => {
  const handleClearText = () => {
    setText('');
    handleTypingSearch('');
  };
  return (
    <View style={style.container}>
      <View style={style.wrapperSearch}>
        <Image resizeMode="center" style={style.icon} source={icons.search} />
      </View>
      <TextInput
        autoFocus={true}
        style={style.input}
        placeholder="Bạn cần tìm gì ?"
        value={text}
        onChangeText={data => {
          setText(data);
          handleTypingSearch(data);
        }}
        onSubmitEditing={() => {
          if (text !== '') {
            navigation.navigate('SearchResult', {
              result: result,
              text: text,
            });
          } else {
            navigation.navigate('SearchResult', {
              result: '',
            });
          }
        }}
      />
      <View style={style.clear}>
        <TouchableOpacity onPress={handleClearText}>
          <Image
            resizeMode="center"
            style={style.icon}
            source={icons.clearText}></Image>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const style = StyleSheet.create({
  container: {
    backgroundColor: '#f5f5f5',
    width: '80%',
    height: 45,
    borderRadius: 40,
    paddingLeft: 10,
    marginTop: 10,
    marginLeft: 20,
    marginBottom: 10,
    flexDirection: 'row',
    borderWidth: 1,
    borderColor: COLORS.primary,
  },
  input: {
    fontFamily: FONTS.fontFamily,
    fontSize: 14,
    flex: 1,
  },
  wrapperSearch: {
    justifyContent: 'center',
    alignItems: 'center',
    width: 40,
    height: 40,
    flex: 0.2,
  },
  icon: {
    width: 20,
    height: 20,
  },
  clear: {
    flex: 0.2,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 5,
  },
});

export default SearchBar;
