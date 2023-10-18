/* eslint-disable prettier/prettier */
import { Text, ScrollView, TouchableOpacity } from 'react-native';
import React from 'react';
import { COLORS, FONTS } from '../constants/theme';

const Categories = (
    {
        categories,
        currentCate,
        setCurrentCate,
    }
) => {
    const Item = ({ data }) => {
        return (
            <TouchableOpacity
                onPress={() => setCurrentCate(data.id)}
                style={{
                    marginRight: 5,
                }}>
                <Text
                    style={currentCate == data.id ? {
                        paddingBottom: 5,
                        paddingHorizontal: 5,
                        fontSize: 22,
                        fontFamily: '',
                        borderRadius: 20,
                        textAlign: 'center',
                        fontWeight: 700,
                        color: COLORS.secondary,
                    } : {
                        padding: 5,
                        fontSize: 20,
                        fontFamily: FONTS.fontFamily,
                        borderRadius: 20,
                        fontWeight: 700,
                        textAlign: 'center',
                    }}
                >{data.name}</Text>
            </TouchableOpacity>
        );
    };
    return (
        <ScrollView
            contentContainerStyle={{
                paddingHorizontal: 15,
                paddingTop: 10,
            }}
            horizontal
            showsHorizontalScrollIndicator={false}
        >
            {/* Category */}
            {categories.map((item, index) => (
                <Item data={item} key={index} />
            ))}
        </ScrollView>
    );
};

export default Categories;